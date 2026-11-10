import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/providers.dart';
import '../../data/repositories/review_repository.dart';
import '../../domain/days.dart';
import '../../domain/enums.dart';
import '../../widgets/chunky_button.dart';
import '../../widgets/stat_pill.dart';
import 'review_providers.dart';
import 'review_session.dart';
import 'widgets/focus_sheet.dart';

/// A Review fül: mennyi esedékes, gyors vegyes kör vagy egy feladattípus.
class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Közben esedékessé válhattak elemek → újra lekérdezzük.
    _lifecycle = AppLifecycleListener(onResume: () => ref.invalidate(reviewDueProvider));
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _start(ReviewMode mode) => context.push('/review/session?mode=${mode.name}');

  @override
  Widget build(BuildContext context) {
    final due = ref.watch(reviewDueProvider).value;
    final focus = ref.watch(reviewFocusProvider);
    final streak = ref.watch(streakProvider);
    final sessionLength = ref.watch(settingsProvider).value?.sessionLength ?? 10;
    final cardTypes = ref.watch(cardTypesProvider);
    final cardsSubtitle = [
      [
        if (cardTypes.contains(ItemType.word)) 'words',
        if (cardTypes.contains(ItemType.phrase)) 'phrases',
        if (cardTypes.contains(ItemType.rule)) 'grammar',
        if (cardTypes.contains(ItemType.sentence)) 'sentences',
      ].join(', ').replaceFirst(RegExp(r', (?=[^,]*$)'), ' & '),
      'EN ↔ HU',
    ].join(' · ');

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 18,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Review',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                  ),
                  StatPill(
                    icon: Icons.local_fire_department_rounded,
                    value: '${streak.current}',
                    tooltip: '${streak.current}-day streak',
                    color: AppColors.streak,
                    background: AppColors.streakBg,
                    dimmed: !streak.activeToday,
                  ),
                ],
              ),
              if (due == null)
                const SizedBox(height: 180, child: Center(child: CircularProgressIndicator()))
              else if (due.total == 0)
                _CaughtUpCard(nextDue: due.nextDue, focused: !focus.isEmpty)
              else
                _DueCard(
                  due: due,
                  minutes: estimateMinutes(selectEntries(due, ReviewMode.mix, sessionLength)),
                  onStart: () => _start(ReviewMode.mix),
                ),
              const Text(
                'Or pick one task',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Column(
                spacing: 10,
                children: [
                  _TaskTile(
                    icon: Icons.style_outlined,
                    title: 'Word cards',
                    // Pl. „Words & phrases · EN ↔ HU” – a beállítás szerint.
                    subtitle: cardsSubtitle[0].toUpperCase() + cardsSubtitle.substring(1),
                    color: AppColors.word,
                    background: AppColors.wordBg,
                    count: due?.cardEntries.length ?? 0,
                    onTap: () => _start(ReviewMode.cards),
                  ),
                  _TaskTile(
                    icon: Icons.view_module_outlined,
                    title: 'Build the sentence',
                    subtitle: 'Word bank · HU → EN · EN → HU',
                    color: AppColors.sentence,
                    background: AppColors.sentenceBg,
                    count: due?.sentenceEntries.length ?? 0,
                    onTap: () => _start(ReviewMode.build),
                  ),
                  _TaskTile(
                    icon: Icons.keyboard_outlined,
                    title: 'Free translation',
                    subtitle: 'Type it yourself · both ways',
                    color: AppColors.phrase,
                    background: AppColors.phraseBg,
                    count: due?.sentenceEntries.length ?? 0,
                    onTap: () => _start(ReviewMode.translate),
                  ),
                ],
              ),
              Row(
                spacing: 8,
                children: [
                  const Expanded(
                    child: Text(
                      'Focus',
                      style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                    ),
                  ),
                  _FocusButton(
                    label: focus.level?.label ?? 'All levels',
                    active: focus.level != null,
                    onTap: () => showReviewFocusSheet(context),
                  ),
                  _FocusButton(
                    label: focus.tagName == null ? 'All tags' : '#${focus.tagName}',
                    active: focus.tagId != null,
                    onTap: () => showReviewFocusSheet(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DueCard extends StatelessWidget {
  const _DueCard({required this.due, required this.minutes, required this.onStart});

  final DueSummary due;
  final int minutes;
  final VoidCallback onStart;

  static const _soft = Color(0xFFD2E5B8);

  @override
  Widget build(BuildContext context) {
    String plural(int n, String one) => n == 1 ? '1 $one' : '$n ${one}s';
    final breakdown = [
      if (due.count(ItemType.word) > 0) plural(due.count(ItemType.word), 'word'),
      if (due.count(ItemType.phrase) > 0) plural(due.count(ItemType.phrase), 'phrase'),
      // A „grammar” megszámlálhatatlan – nincs „grammars”.
      if (due.count(ItemType.rule) > 0) '${due.count(ItemType.rule)} grammar',
      if (due.count(ItemType.sentence) > 0) plural(due.count(ItemType.sentence), 'sentence'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.accentBg, borderRadius: BorderRadius.circular(28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    const Text(
                      'DUE TODAY',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: _soft,
                      ),
                    ),
                    Text(
                      '${due.total}',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        height: 1,
                        color: AppColors.accent,
                      ),
                    ),
                    Text(
                      due.total == 1 ? 'item ready to review' : 'items ready to review',
                      style: const TextStyle(fontSize: 14, color: _soft),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 6,
                children: [
                  for (final line in breakdown)
                    Text(line, style: const TextStyle(fontSize: 12, color: _soft)),
                ],
              ),
            ],
          ),
          ChunkyButton(
            label: 'Quick mix · ~$minutes min',
            icon: Icons.play_arrow_rounded,
            onPressed: onStart,
          ),
        ],
      ),
    );
  }
}

class _CaughtUpCard extends StatelessWidget {
  const _CaughtUpCard({required this.nextDue, required this.focused});

  final DateTime? nextDue;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    final next = nextDue;
    final String subtitle;
    if (next == null) {
      subtitle = focused
          ? 'Nothing matches this focus yet.'
          : 'Add a few words or sentences to start reviewing.';
    } else {
      subtitle = 'Next review ${_nextDueLabel(next, DateTime.now())}.';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.accentBg, borderRadius: BorderRadius.circular(28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          const Icon(Icons.check_circle_rounded, size: 40, color: AppColors.accent),
          Text(
            next == null && !focused ? 'Your box is empty' : 'All caught up!',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          Text(subtitle, style: const TextStyle(fontSize: 14, color: Color(0xFFD2E5B8))),
          if (next == null && !focused) ...[
            const SizedBox(height: 4),
            ChunkyButton(
              label: 'Add an item',
              icon: Icons.add_rounded,
              onPressed: () => context.push('/add'),
            ),
          ],
        ],
      ),
    );
  }
}

/// „tomorrow”, „in 3 days”, „in 2 h”
String _nextDueLabel(DateTime due, DateTime now) {
  final days = dayNumber(due) - dayNumber(now);
  if (days == 1) return 'tomorrow';
  if (days > 1) return 'in $days days';
  final minutes = due.difference(now).inMinutes;
  if (minutes < 60) return 'in ${minutes < 1 ? 1 : minutes} min';
  return 'in ${(minutes / 60).round()} h';
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.background,
    required this.count,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color background;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = count > 0;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              spacing: 14,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, size: 22, color: color),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$count',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FocusButton extends StatelessWidget {
  const _FocusButton({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.accent : AppColors.text;
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        side: BorderSide(color: active ? AppColors.accent : AppColors.borderStrong, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontFamily: 'Lexend', fontSize: 13, fontWeight: FontWeight.w600),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [Text(label), const Icon(Icons.expand_more_rounded, size: 16)],
      ),
    );
  }
}

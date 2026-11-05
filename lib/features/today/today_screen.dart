import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/format.dart';
import '../../app/theme.dart';
import '../../data/providers.dart';
import '../../domain/enums.dart';
import '../../domain/quests.dart';
import '../library/library_filter.dart';
import 'widgets/box_grid.dart';
import 'widgets/level_card.dart';
import 'widgets/quest_card.dart';
import 'widgets/quick_capture.dart';
import 'widgets/today_header.dart';

/// A kezdőképernyő: szint, streak, napi küldetések, gyorsrögzítés, „Your box”.
class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Ha az app éjfél után kerül újra előtérbe, új nap kezdődik: frissülnek a
    // küldetések, és az esedékes ismétlések száma is.
    _lifecycle = AppLifecycleListener(
      onResume: () {
        ref.read(currentDayProvider.notifier).refresh();
        ref.invalidate(boxStatsProvider);
      },
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _claim(QuestProgress quest) async {
    final day = ref.read(currentDayProvider);
    final claimed = await ref
        .read(activityRepositoryProvider)
        .claimQuest(quest.quest, day, quest.reward);
    if (!claimed || !mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Quest complete · +${quest.reward} XP')));
  }

  void _openQuest(QuestProgress quest) {
    switch (quest.quest) {
      case Quest.addItems:
        context.push('/add');
      case Quest.reviewItems:
        context.go('/review');
      case Quest.ownExample:
        // Saját példát egy szó/kifejezés részletén lehet írni.
        _openLibrary(null);
    }
  }

  /// A Library fülre vált, a megadott típusra szűrve (a többi szűrőt törli).
  void _openLibrary(ItemType? type) {
    ref.read(libraryFilterProvider.notifier)
      ..reset()
      ..setType(type);
    context.go('/library');
  }

  @override
  Widget build(BuildContext context) {
    final level = ref.watch(levelProvider);
    final quests = ref.watch(dailyQuestsProvider);
    final stats = ref.watch(boxStatsProvider).value;
    final gameMode = ref.watch(gameModeProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 18,
            children: [
              const TodayHeader(),
              if (gameMode) LevelCard(level: level),
              if (gameMode)
                _Section(
                  title: 'Daily quests',
                  trailing: Text(
                    'Resets in ${untilMidnight(DateTime.now())}',
                    style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                  children: [
                    if (quests == null)
                      const SizedBox(height: 72, child: Center(child: CircularProgressIndicator()))
                    else
                      for (final quest in quests)
                        QuestCard(
                          quest: quest,
                          onTap: () => _openQuest(quest),
                          onClaim: () => _claim(quest),
                        ),
                  ],
                ),
              const QuickCapture(),
              _Section(
                title: 'Your box',
                trailing: TextButton(
                  onPressed: () => _openLibrary(null),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    textStyle: const TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('See all'),
                ),
                children: [
                  if (stats != null)
                    BoxGrid(
                      stats: stats,
                      onType: _openLibrary,
                      onMastered: () => context.go('/progress'),
                      onTags: () => context.push('/tags'),
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

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children, this.trailing});

  final String title;
  final Widget? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            ?trailing,
          ],
        ),
        ...children,
      ],
    );
  }
}

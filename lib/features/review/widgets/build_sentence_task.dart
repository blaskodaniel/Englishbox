import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../domain/review_text.dart';
import '../../../domain/srs.dart';
import '../../../widgets/chunky_button.dart';
import '../review_session.dart';
import 'session_parts.dart';

/// Mondatépítés szócsempékből. Helyes → „Spot on!”, hibás → „Not quite”
/// (Try again / Continue). Ha újrapróbálás után sikerül, az „Hard”-nak számít.
class BuildSentenceTask extends StatefulWidget {
  const BuildSentenceTask({
    super.key,
    required this.card,
    required this.onGrade,
    required this.onNext,
    required this.onUseKeyboard,
    this.showXp = true,
  });

  /// Játék mód nélkül a visszajelzésben sincs „+10 XP”.
  final bool showXp;

  final ReviewCard card;

  /// Értékel és visszaadja az eredményt (XP, tudásszint-változás) a panelhez.
  final AnswerOutcome Function(ReviewGrade grade) onGrade;
  final VoidCallback onNext;
  final VoidCallback onUseKeyboard;

  @override
  State<BuildSentenceTask> createState() => _BuildSentenceTaskState();
}

enum _Phase { building, correct, wrong }

class _BuildSentenceTaskState extends State<BuildSentenceTask> {
  /// A lerakott csempék indexei (a `card.tiles` listában), sorrendben.
  final List<int> _placed = [];
  _Phase _phase = _Phase.building;
  bool _retried = false;
  AnswerOutcome? _outcome;

  List<String> get _tiles => widget.card.tiles;

  void _place(int index) {
    if (_phase != _Phase.building || _placed.contains(index)) return;
    setState(() => _placed.add(index));
  }

  void _remove(int position) {
    if (_phase != _Phase.building) return;
    setState(() => _placed.removeAt(position));
  }

  void _check() {
    final built = _placed.map((i) => _tiles[i]).join(' ');
    if (sameSentence(built, widget.card.answer)) {
      final outcome = widget.onGrade(_retried ? ReviewGrade.hard : ReviewGrade.good);
      setState(() {
        _outcome = outcome;
        _phase = _Phase.correct;
      });
    } else {
      setState(() => _phase = _Phase.wrong);
    }
  }

  void _retry() => setState(() {
    _placed.clear();
    _retried = true;
    _phase = _Phase.building;
  });

  void _giveUp() {
    widget.onGrade(ReviewGrade.forgot);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 18,
              children: [
                TaskLabel(
                  label: card.toEnglish ? 'Build it in English' : 'Build it in Hungarian',
                  color: AppColors.sentence,
                  trailing: _phase == _Phase.building
                      ? TextButton.icon(
                          onPressed: widget.onUseKeyboard,
                          icon: const Icon(Icons.keyboard_outlined, size: 16),
                          label: const Text('Use keyboard'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.accent,
                            visualDensity: VisualDensity.compact,
                            textStyle: const TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : null,
                ),
                PromptBubble(
                  code: card.toEnglish ? 'HU' : 'EN',
                  text: card.prompt,
                  color: AppColors.sentence,
                  background: AppColors.sentenceBg,
                ),
                _AnswerArea(
                  children: [
                    for (final (position, index) in _placed.indexed)
                      _Tile(label: _tiles[index], onTap: () => _remove(position)),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final (index, label) in _tiles.indexed)
                      _placed.contains(index)
                          ? _Tile(label: label, used: true)
                          : _Tile(label: label, onTap: () => _place(index)),
                  ],
                ),
              ],
            ),
          ),
        ),
        switch (_phase) {
          _Phase.building => Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: ChunkyButton(label: 'Check', onPressed: _placed.isEmpty ? null : _check),
          ),
          _Phase.correct => FeedbackPanel.correct(
            outcome: _outcome!,
            itemName: card.item.english,
            showXp: widget.showXp,
            onContinue: widget.onNext,
          ),
          _Phase.wrong => FeedbackPanel.wrong(
            correctAnswer: card.answer,
            onRetry: _retry,
            onContinue: _giveUp,
          ),
        },
      ],
    );
  }
}

/// A „vonalas papír”, amire a csempék kerülnek.
class _AnswerArea extends StatelessWidget {
  const _AnswerArea({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 116),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderStrong, width: 2)),
      ),
      child: Wrap(spacing: 8, runSpacing: 10, children: children),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, this.onTap, this.used = false});

  final String label;
  final VoidCallback? onTap;

  /// Már lerakott csempe helye a bankban: szaggatott, üres.
  final bool used;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: used ? AppColors.input : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: used ? AppColors.borderStrong : const Color(0xFF3A4256),
            width: 2,
          ),
          boxShadow: used
              ? null
              : const [BoxShadow(color: AppColors.borderStrong, offset: Offset(0, 3))],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: used ? Colors.transparent : AppColors.text,
          ),
        ),
      ),
    );
  }
}

/// Alsó visszajelző panel: zöld „Spot on!” vagy piros „Not quite”.
class FeedbackPanel extends StatelessWidget {
  const FeedbackPanel.correct({
    super.key,
    required AnswerOutcome this.outcome,
    required String this.itemName,
    required this.onContinue,
    this.showXp = true,
  }) : correctAnswer = null,
       onRetry = null;

  const FeedbackPanel.wrong({
    super.key,
    required String this.correctAnswer,
    required VoidCallback this.onRetry,
    required this.onContinue,
  }) : outcome = null,
       itemName = null,
       showXp = false;

  final bool showXp;

  final AnswerOutcome? outcome;
  final String? itemName;
  final String? correctAnswer;
  final VoidCallback? onRetry;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final ok = outcome != null;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      decoration: BoxDecoration(
        color: ok ? AppColors.accentBg : AppColors.wrongBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: ok ? _correct() : _wrong(),
      ),
    );
  }

  List<Widget> _correct() {
    final o = outcome!;
    final title = o.grade == ReviewGrade.good ? 'Spot on!' : 'Got it!';
    return [
      Row(
        spacing: 10,
        children: [
          const Icon(Icons.check_rounded, size: 26, color: AppColors.accent),
          Text(
            showXp && o.xp > 0 ? '$title +${o.xp} XP' : title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
      if (o.movedUp)
        Text(
          '„$itemName” moved up to ${o.after.label}.',
          style: const TextStyle(fontSize: 14, color: Color(0xFFD2E5B8)),
        ),
      const SizedBox(height: 2),
      ChunkyButton(label: 'Continue', onPressed: onContinue),
    ];
  }

  List<Widget> _wrong() => [
    const Text(
      'Not quite',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.wrong),
    ),
    const Text('Correct answer:', style: TextStyle(fontSize: 13, color: AppColors.wrongText)),
    Text(correctAnswer!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    const SizedBox(height: 2),
    Row(
      spacing: 10,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.wrong,
              minimumSize: const Size.fromHeight(56),
              side: const BorderSide(color: AppColors.wrongBorder, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              textStyle: const TextStyle(
                fontFamily: 'Lexend',
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: const Text('Try again'),
          ),
        ),
        Expanded(
          child: ChunkyButton(
            label: 'Continue',
            color: AppColors.wrong,
            shadowColor: const Color(0xFFA8483C),
            foreground: const Color(0xFF2A0E0A),
            height: 52,
            onPressed: onContinue,
          ),
        ),
      ],
    ),
  ];
}

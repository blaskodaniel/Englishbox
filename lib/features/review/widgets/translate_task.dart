import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../domain/review_text.dart';
import '../../../domain/srs.dart';
import '../../../widgets/chunky_button.dart';
import '../review_session.dart';
import 'grade_buttons.dart';
import 'session_parts.dart';

/// Szabad fordítás: beírod, összeveted a mentett fordítással (a különbségek
/// kiemelve), majd te értékeled magad: Wrong / Almost / Correct.
class TranslateTask extends StatefulWidget {
  const TranslateTask({super.key, required this.card, required this.onGrade});

  final ReviewCard card;
  final ValueChanged<ReviewGrade> onGrade;

  @override
  State<TranslateTask> createState() => _TranslateTaskState();
}

class _TranslateTaskState extends State<TranslateTask> {
  final _controller = TextEditingController();
  late bool _toEnglish = widget.card.toEnglish;
  bool _checked = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _prompt => _toEnglish ? widget.card.item.hungarian : widget.card.item.english;
  String get _expected => _toEnglish ? widget.card.item.english : widget.card.item.hungarian;

  void _setDirection(bool toEnglish) {
    if (_checked || toEnglish == _toEnglish) return;
    setState(() {
      _toEnglish = toEnglish;
      _controller.clear();
    });
  }

  void _check() {
    FocusScope.of(context).unfocus();
    setState(() => _checked = true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                _DirectionToggle(
                  toEnglish: _toEnglish,
                  enabled: !_checked,
                  onChanged: _setDirection,
                ),
                PromptBubble(
                  code: _toEnglish ? 'HU' : 'EN',
                  text: _prompt,
                  color: AppColors.phrase,
                  background: AppColors.phraseBg,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 6,
                  children: [
                    Text(
                      'Your translation (${_toEnglish ? 'English' : 'Hungarian'})',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                    TextField(
                      controller: _controller,
                      readOnly: _checked,
                      minLines: 3,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(fontSize: 17, height: 1.45),
                      decoration: InputDecoration(enabledBorder: _border, focusedBorder: _border),
                    ),
                  ],
                ),
                if (_checked)
                  _Comparison(expected: _expected, answer: _controller.text)
                else
                  const Text(
                    "You'll compare your answer with your saved translation and grade "
                    'yourself. Differences get highlighted.',
                    style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.textMuted),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: _checked
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 10,
                  children: [
                    const Text(
                      'How did you do?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    GradeButtons(
                      options: const [
                        GradeOption(ReviewGrade.forgot, 'Wrong'),
                        GradeOption(ReviewGrade.hard, 'Almost'),
                        GradeOption(ReviewGrade.good, 'Correct'),
                      ],
                      onGrade: widget.onGrade,
                    ),
                  ],
                )
              // Üresen is ellenőrizhető – akkor egyszerűen megmutatja a megoldást.
              : ChunkyButton(label: 'Check', onPressed: _check),
        ),
      ],
    );
  }

  static final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color: AppColors.phrase, width: 2),
  );
}

class _DirectionToggle extends StatelessWidget {
  const _DirectionToggle({required this.toEnglish, required this.enabled, required this.onChanged});

  final bool toEnglish;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget segment(String label, bool value) {
      final selected = toEnglish == value;
      return Expanded(
        child: GestureDetector(
          onTap: enabled ? () => onChanged(value) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.phrase : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: selected ? const Color(0xFF17102E) : AppColors.textSoft,
              ),
            ),
          ),
        ),
      );
    }

    return Semantics(
      label: 'Direction',
      child: Opacity(
        opacity: enabled ? 1 : 0.6,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.input,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderStrong, width: 2),
          ),
          child: Row(children: [segment('HU → EN', true), segment('EN → HU', false)]),
        ),
      ),
    );
  }
}

/// „Saved translation” – a kihagyott szavak zölden, a te eltérő szavaid pirosan.
class _Comparison extends StatelessWidget {
  const _Comparison({required this.expected, required this.answer});

  final String expected;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final diff = diffWords(expected, answer);
    final perfect = answer.trim().isNotEmpty && sameSentence(expected, answer);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            perfect ? 'SAVED TRANSLATION · PERFECT MATCH' : 'SAVED TRANSLATION',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: perfect ? AppColors.accent : AppColors.textMuted,
            ),
          ),
          _tokens(
            diff.expected,
            const TextStyle(fontSize: 16, height: 1.6, color: AppColors.text),
            AppColors.sentence,
            AppColors.sentenceBg,
          ),
          if (!perfect)
            answer.trim().isEmpty
                ? const Text(
                    'You left it empty.',
                    style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                  )
                : Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'You wrote: '),
                        _spans(diff.answer, AppColors.wrong, AppColors.wrongBg),
                      ],
                    ),
                    style: const TextStyle(fontSize: 14, height: 1.6, color: AppColors.textMuted),
                  ),
        ],
      ),
    );
  }

  Widget _tokens(List<DiffToken> tokens, TextStyle style, Color color, Color background) =>
      Text.rich(_spans(tokens, color, background), style: style);

  /// A szavak szóközzel elválasztva; a nem egyezők színes „kiemelővel”.
  TextSpan _spans(List<DiffToken> tokens, Color color, Color background) => TextSpan(
    children: [
      for (final (i, token) in tokens.indexed) ...[
        if (i > 0) const TextSpan(text: ' '),
        token.matched
            ? TextSpan(text: token.text)
            : TextSpan(
                text: token.text,
                style: TextStyle(
                  color: color,
                  backgroundColor: background,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ],
    ],
  );
}

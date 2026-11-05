import 'package:flutter/material.dart';

import '../../../app/labels.dart';
import '../../../app/theme.dart';
import '../../../domain/enums.dart';
import '../../../domain/note_markup.dart';
import '../../../domain/srs.dart';
import '../../../widgets/chunky_button.dart';
import '../../../widgets/highlighted_text.dart';
import '../review_session.dart';
import 'grade_buttons.dart';
import 'session_parts.dart';

/// Szókártya: előlap → „Show answer” → hátlap → Forgot / Hard / Knew it.
class WordCardTask extends StatefulWidget {
  const WordCardTask({
    super.key,
    required this.card,
    required this.counter,
    required this.onGrade,
    required this.onSpeak,
  });

  final ReviewCard card;
  final String counter;
  final ValueChanged<ReviewGrade> onGrade;
  final ValueChanged<String> onSpeak;

  @override
  State<WordCardTask> createState() => _WordCardTaskState();
}

class _WordCardTaskState extends State<WordCardTask> {
  bool _flipped = false;

  void _flip() {
    setState(() => _flipped = true);
    // Magyarról angolra: felfordításkor rögtön meg is hallod a helyes kiejtést.
    if (widget.card.toEnglish) widget.onSpeak(widget.card.item.english);
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final item = card.item;
    final type = item.type;
    final isRule = type == ItemType.rule;
    final darkOnType = Color.lerp(type.color, Colors.black, 0.85)!;

    final label = isRule
        ? 'Grammar card'
        : card.toEnglish
        ? 'Word cards · HU → EN'
        : 'Word cards · EN → HU';
    final hint = isRule
        ? 'Recall the form and when to use it, then reveal.'
        : card.toEnglish
        ? 'Say it in English out loud, then reveal.'
        : 'Say the meaning out loud, then reveal.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                TaskLabel(
                  label: label,
                  color: type.color,
                  trailing: Text(
                    widget.counter,
                    style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: type.background,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: type.softBorder, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Color.lerp(type.background, Colors.black, 0.4)!,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          spacing: 14,
                          children: [
                            _badges(darkOnType),
                            ..._front(darkOnType),
                            if (_flipped) _back(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (!_flipped)
                  Text(
                    hint,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: _flipped
              ? GradeButtons(
                  options: [
                    for (final (grade, text) in const [
                      (ReviewGrade.forgot, 'Forgot'),
                      (ReviewGrade.hard, 'Hard'),
                      (ReviewGrade.good, 'Knew it'),
                    ])
                      GradeOption(
                        grade,
                        text,
                        Srs.intervalLabel(Srs.nextInterval(card.srs, grade)),
                      ),
                  ],
                  onGrade: widget.onGrade,
                )
              : ChunkyButton(
                  label: 'Show answer',
                  color: type.color,
                  shadowColor: Color.lerp(type.color, Colors.black, 0.45)!,
                  foreground: darkOnType,
                  onPressed: _flip,
                ),
        ),
      ],
    );
  }

  Widget _badges(Color darkOnType) {
    final item = widget.card.item;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      children: [
        _Badge(
          text: itemKindLabel(item).toUpperCase(),
          background: item.type.color,
          foreground: darkOnType,
        ),
        if (item.level != null) _Badge(text: item.level!.label, border: item.type.color),
      ],
    );
  }

  /// Az előlap: angolról → a szó + kiejtés; magyarról → a magyar jelentés.
  List<Widget> _front(Color darkOnType) {
    final card = widget.card;
    final item = card.item;
    if (card.toEnglish) {
      return [_title(item.hungarian)];
    }
    return [
      _title(item.english),
      if (item.ipa != null)
        Text(item.ipa!, style: const TextStyle(fontSize: 16, color: AppColors.textSoft)),
      if (item.type != ItemType.rule)
        _SpeakButton(
          color: item.type.color,
          foreground: darkOnType,
          onPressed: () => widget.onSpeak(item.english),
        ),
    ];
  }

  Widget _title(String text) {
    final long = text.length > 24;
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: long ? 26 : 44, fontWeight: FontWeight.w800, height: 1.15),
    );
  }

  /// A hátlap a szaggatott vonal alatt.
  Widget _back() {
    final card = widget.card;
    final item = card.item;
    final color = item.type.color;
    final darkOnType = Color.lerp(color, Colors.black, 0.85)!;
    final example = card.example;

    final children = <Widget>[
      if (card.toEnglish) ...[
        Text(
          item.english,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color),
        ),
        if (item.ipa != null)
          Text(item.ipa!, style: const TextStyle(fontSize: 15, color: AppColors.textSoft)),
        _SpeakButton(
          color: color,
          foreground: darkOnType,
          onPressed: () => widget.onSpeak(item.english),
        ),
      ] else if (item.type == ItemType.rule) ...[
        if (item.formula.isNotEmpty)
          Text(
            formulaText(item.formula),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color),
          ),
        if ((item.notes ?? '').trim().isNotEmpty)
          Text(
            item.notes!.trim().split('\n').map(stripNoteMarkup).join('\n'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, height: 1.45, color: AppColors.textSoft),
          ),
      ] else
        Text(
          item.hungarian.trim().isEmpty ? 'No translation saved yet' : item.hungarian,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: item.hungarian.trim().isEmpty ? AppColors.textMuted : color,
          ),
        ),
      if (example != null) ...[
        HighlightedText(
          example.english,
          highlight: item.type == ItemType.rule ? '' : item.english,
          color: AppColors.text,
          style: const TextStyle(fontSize: 15, height: 1.45, color: AppColors.textSoft),
        ),
        // A példamondat magyarul is – halványabban, dőlten.
        if (example.hungarian.trim().isNotEmpty)
          Text(
            example.hungarian.trim(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              fontStyle: FontStyle.italic,
              color: AppColors.textMuted,
            ),
          ),
      ],
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: item.type.softBorder, width: 2)),
      ),
      child: Column(spacing: 10, children: children),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.text,
    this.background,
    this.foreground = AppColors.text,
    this.border,
  });

  final String text;
  final Color? background;
  final Color foreground;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: border == null ? null : Border.all(color: border!, width: 1.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: foreground,
        ),
      ),
    );
  }
}

class _SpeakButton extends StatelessWidget {
  const _SpeakButton({required this.color, required this.foreground, required this.onPressed});

  final Color color;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Play pronunciation',
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: Color.lerp(color, Colors.black, 0.4)!, offset: const Offset(0, 4)),
            ],
          ),
          child: Icon(Icons.volume_up_rounded, size: 26, color: foreground),
        ),
      ),
    );
  }
}

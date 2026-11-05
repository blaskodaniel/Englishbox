import 'package:flutter/material.dart';

import '../../../app/labels.dart';
import '../../../app/theme.dart';
import '../../../domain/enums.dart';
import '../../../domain/xp.dart';
import '../../../widgets/field_label.dart';
import '../../../widgets/highlighted_text.dart';
import '../example_draft.dart';

/// Példamondatok listája + új példa beviteli doboza.
///
/// A lista állapotát a szülő tartja ([examples] + [onChanged]) – mint egy
/// „controlled component” Reactben. Az új példa két mezőjének controllereit is
/// a szülő adja, hogy mentéskor a félig beírt példát is el tudja menteni.
class ExamplesEditor extends StatelessWidget {
  const ExamplesEditor({
    super.key,
    required this.type,
    required this.term,
    required this.examples,
    required this.onChanged,
    required this.newEnglish,
    required this.newSecond,
    this.editing = false,
  });

  final ItemType type;

  /// A kiemelendő szó/kifejezés.
  final String term;
  final List<ExampleDraft> examples;
  final ValueChanged<List<ExampleDraft>> onChanged;
  final TextEditingController newEnglish;
  final TextEditingController newSecond;

  /// Szerkesztő mód: más súgószöveg (a kivett példa mondatként megmarad).
  final bool editing;

  bool get _isRule => type == ItemType.rule;

  void _add() {
    final english = newEnglish.text.trim();
    if (english.isEmpty) return;
    final second = newSecond.text.trim();
    onChanged([
      ...examples,
      ExampleDraft(english: english, second: second.isEmpty ? null : second),
    ]);
    newEnglish.clear();
    newSecond.clear();
  }

  void _remove(int index) => onChanged([...examples]..removeAt(index));

  void _setCorrect(int index, bool isCorrect) {
    final next = [...examples];
    next[index] = next[index].copyWith(isCorrect: isCorrect);
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        FieldLabel(
          'Example sentences · ${examples.length}',
          trailing: const Text(
            '+${XpRules.perExample} XP each',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent),
          ),
        ),
        for (final (index, example) in examples.indexed)
          _ExampleCard(
            example: example,
            type: type,
            term: term,
            showCorrectToggle: _isRule,
            onRemove: () => _remove(index),
            onSetCorrect: (value) => _setCorrect(index, value),
          ),
        _NewExampleBox(english: newEnglish, second: newSecond, onSubmit: _add),
        OutlinedButton.icon(
          onPressed: _add,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Add example'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.text,
            minimumSize: const Size.fromHeight(46),
            side: const BorderSide(color: AppColors.borderStrong, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(
              fontFamily: 'Lexend',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          editing
              ? 'New examples go to your Sentences too. '
                    'Removed examples stay in your box as sentences.'
              : _isRule
              ? 'Correct examples also go to your Sentences, so they show up in review.'
              : 'The ${type.label.toLowerCase()} is highlighted automatically. '
                    'Examples also go to your Sentences for review.',
          style: const TextStyle(fontSize: 12, height: 1.5, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.example,
    required this.type,
    required this.term,
    required this.showCorrectToggle,
    required this.onRemove,
    required this.onSetCorrect,
  });

  final ExampleDraft example;
  final ItemType type;
  final String term;
  final bool showCorrectToggle;
  final VoidCallback onRemove;
  final ValueChanged<bool> onSetCorrect;

  @override
  Widget build(BuildContext context) {
    final borderColor = !showCorrectToggle
        ? type.softBorder
        : example.isCorrect
        ? AppColors.sentenceSoft
        : AppColors.wrongBorder;

    final removeButton = IconButton(
      tooltip: 'Remove example',
      onPressed: onRemove,
      icon: const Icon(Icons.delete_outline_rounded, size: 18),
      color: AppColors.textMuted,
      visualDensity: VisualDensity.compact,
    );

    final sentence = example.isCorrect
        ? HighlightedText(
            example.english,
            highlight: showCorrectToggle ? '' : term,
            color: type.color,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.45),
          )
        : Text(
            example.english,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.45,
              color: AppColors.wrongText,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppColors.wrong,
            ),
          );

    final texts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        sentence,
        if (example.second != null)
          Text(example.second!, style: const TextStyle(fontSize: 14, color: AppColors.textMuted)),
      ],
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 6, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: showCorrectToggle
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 4,
              children: [
                Row(
                  children: [
                    _CorrectToggle(isCorrect: example.isCorrect, onChanged: onSetCorrect),
                    const Spacer(),
                    removeButton,
                  ],
                ),
                Padding(padding: const EdgeInsets.only(right: 8), child: texts),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(padding: const EdgeInsets.only(top: 4), child: texts),
                ),
                removeButton,
              ],
            ),
    );
  }
}

class _CorrectToggle extends StatelessWidget {
  const _CorrectToggle({required this.isCorrect, required this.onChanged});

  final bool isCorrect;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget option(String label, bool value, Color color, Color background) {
      final selected = isCorrect == value;
      return GestureDetector(
        onTap: () => onChanged(value),
        child: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? background : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              color: selected ? color : AppColors.textMuted,
            ),
          ),
        ),
      );
    }

    return Row(
      spacing: 4,
      children: [
        option('✓ Correct', true, AppColors.sentence, AppColors.sentenceBg),
        option('✗ Wrong', false, AppColors.wrong, AppColors.wrongBg),
      ],
    );
  }
}

class _NewExampleBox extends StatelessWidget {
  const _NewExampleBox({required this.english, required this.second, required this.onSubmit});

  final TextEditingController english;
  final TextEditingController second;
  final VoidCallback onSubmit;

  static const _bare = InputDecoration(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    filled: false,
    isDense: true,
    contentPadding: EdgeInsets.symmetric(vertical: 10),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.dashed, width: 2),
      ),
      child: Column(
        children: [
          TextField(
            controller: english,
            decoration: _bare.copyWith(hintText: 'Type a new example sentence…'),
            style: const TextStyle(fontSize: 15),
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
          ),
          const Divider(height: 1, color: AppColors.borderStrong),
          TextField(
            controller: second,
            decoration: _bare.copyWith(hintText: 'Hungarian translation (optional)'),
            style: const TextStyle(fontSize: 14),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSubmit(),
          ),
        ],
      ),
    );
  }
}

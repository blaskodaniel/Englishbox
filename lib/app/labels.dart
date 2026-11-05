import 'package:flutter/material.dart';

import '../data/db.dart';
import '../domain/enums.dart';
import '../domain/formula.dart';
import 'theme.dart';

/// Az elem fajtájának felirata: „Adjective”, „Phrasal verb”, „Grammar”…
String itemKindLabel(Item item) => switch (item.type) {
  ItemType.word => _capitalize(item.partOfSpeech?.label ?? 'word'),
  ItemType.phrase => _capitalize(item.phraseKind?.label ?? 'phrase'),
  ItemType.rule => 'Grammar',
  ItemType.sentence => 'Sentence',
};

/// „have/has + been + verb-ing”
String formulaText(List<FormulaBlock> blocks) => blocks.map((b) => b.text).join(' + ');

/// Rövid alcím a listákhoz: jelentés, szabálynál a képlet.
String itemSubtitle(Item item) {
  if (item.type == ItemType.rule) {
    if (item.formula.isNotEmpty) return formulaText(item.formula);
    return (item.notes ?? '').split('\n').first;
  }
  return item.hungarian;
}

String _capitalize(String text) => text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);

/// Elemtípusonkénti színek és feliratok – mint egy `typeStyles[type]` lookup.
extension ItemTypeStyle on ItemType {
  Color get color => switch (this) {
    ItemType.word => AppColors.word,
    ItemType.phrase => AppColors.phrase,
    ItemType.rule => AppColors.rule,
    ItemType.sentence => AppColors.sentence,
  };

  Color get background => switch (this) {
    ItemType.word => AppColors.wordBg,
    ItemType.phrase => AppColors.phraseBg,
    ItemType.rule => AppColors.ruleBg,
    ItemType.sentence => AppColors.sentenceBg,
  };

  Color get softBorder => switch (this) {
    ItemType.word => AppColors.wordSoft,
    ItemType.phrase => AppColors.phraseSoft,
    ItemType.rule => AppColors.ruleSoft,
    ItemType.sentence => AppColors.sentenceSoft,
  };

  String get label => switch (this) {
    ItemType.word => 'Word',
    ItemType.phrase => 'Phrase',
    ItemType.rule => 'Rule',
    ItemType.sentence => 'Sentence',
  };

  /// Az Add képernyő címe.
  String get newTitle => switch (this) {
    ItemType.word => 'New word',
    ItemType.phrase => 'New phrase',
    ItemType.rule => 'New grammar rule',
    ItemType.sentence => 'New sentence',
  };

  /// A fő (angol) mező felirata.
  String get englishLabel => switch (this) {
    ItemType.word => 'English',
    ItemType.phrase => 'Expression',
    ItemType.rule => 'Rule name',
    ItemType.sentence => 'Sentence',
  };
}

extension PartOfSpeechLabel on PartOfSpeech {
  String get label => name; // noun, verb, adjective, adverb
}

extension PhraseKindLabel on PhraseKind {
  String get label => switch (this) {
    PhraseKind.idiom => 'idiom',
    PhraseKind.phrasalVerb => 'phrasal verb',
    PhraseKind.collocation => 'collocation',
  };
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/labels.dart';
import '../../app/theme.dart';
import '../../data/providers.dart';
import '../../domain/drafts.dart';
import '../../domain/enums.dart';
import '../../domain/formula.dart';
import '../../domain/xp.dart';
import '../../services/speech_service.dart';
import '../../widgets/chunky_button.dart';
import '../../widgets/field_label.dart';
import '../../widgets/level_picker.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/select_chip.dart';
import '../../widgets/text_input_dialog.dart';
import 'example_draft.dart';
import 'widgets/examples_editor.dart';
import 'widgets/formula_editor.dart';
import 'widgets/ipa_field.dart';
import 'widgets/notes_editor.dart';
import 'widgets/tags_source_row.dart';
import 'widgets/type_selector.dart';

/// Új elem hozzáadása (szó, kifejezés, nyelvtani szabály vagy mondat) – vagy
/// egy meglévő szerkesztése, ha [editItemId] meg van adva.
///
/// Az űrlap állapota helyi (`State`), mint egy React komponens `useState`-jei;
/// mentéskor a repositoryn keresztül egy tranzakcióban kerül az adatbázisba.
class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({
    super.key,
    this.initialType = ItemType.word,
    this.initialText = '',
    this.editItemId,
  });

  final ItemType initialType;

  /// A Today gyorsrögzítő mezőjéből érkező szöveg.
  final String initialText;

  /// Szerkesztő mód: a meglévő elem azonosítója.
  final int? editItemId;

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  late ItemType _type = widget.initialType;

  late final _english = TextEditingController(text: widget.initialText);
  final _hungarian = TextEditingController();
  final _ipa = TextEditingController();
  final _notes = TextEditingController();
  final _trapNote = TextEditingController();
  final _newExample = TextEditingController();
  final _newExampleSecond = TextEditingController();

  PartOfSpeech? _partOfSpeech;
  PhraseKind? _phraseKind;
  CefrLevel? _level;
  String? _ruleCategory;
  List<FormulaBlock> _formula = [];
  bool _showTrapNote = false;
  List<ExampleDraft> _examples = [];
  List<String> _tags = [];
  String? _source;
  bool _saving = false;

  /// Szerkesztéskor `false`, amíg az elem be nem töltődött.
  late bool _loaded = !_isEditing;

  /// Szerkesztéskor: az elem már nem létezik.
  bool _missing = false;

  bool get _isEditing => widget.editItemId != null;

  @override
  void initState() {
    super.initState();
    // A gomb engedélyezése és az XP-előnézet a beírt szövegtől függ.
    _english.addListener(_refresh);
    _newExample.addListener(_refresh);

    if (_isEditing) {
      _load(widget.editItemId!);
    } else {
      // Alapértelmezett szint: a felhasználó saját szintje a beállításokból.
      ref.read(settingsRepositoryProvider).get().then((settings) {
        if (mounted && _level == null) {
          setState(() => _level = settings.levelNow);
        }
      });
    }
  }

  void _refresh() => setState(() {});

  /// Egyszeri betöltés (nem élő stream): szerkesztés közben ne írja felül
  /// az űrlapot, ha közben valami más módosítja az adatbázist.
  Future<void> _load(int id) async {
    final detail = await ref.read(itemsRepositoryProvider).getItemDetail(id);
    if (!mounted) return;
    if (detail == null) {
      setState(() => _missing = true);
      return;
    }

    final item = detail.item;
    _english.text = item.english;
    _hungarian.text = item.hungarian;
    _ipa.text = item.ipa ?? '';
    _notes.text = item.notes ?? '';
    _trapNote.text = item.trapNote ?? '';

    setState(() {
      _type = item.type;
      _partOfSpeech = item.partOfSpeech;
      _phraseKind = item.phraseKind;
      _level = item.level;
      _ruleCategory = item.ruleCategory;
      _formula = [...item.formula];
      _showTrapNote = item.trapNote != null;
      _tags = [for (final tag in detail.tags) tag.name];
      _source = item.source;
      _examples = [
        for (final sentence in detail.examples)
          ExampleDraft(
            english: sentence.english,
            second: sentence.hungarian.isEmpty ? null : sentence.hungarian,
            sentenceId: sentence.id,
          ),
        for (final mistake in detail.mistakes)
          ExampleDraft(english: mistake.wrong, second: mistake.explanation, isCorrect: false),
      ];
      _loaded = true;
    });
  }

  @override
  void dispose() {
    for (final controller in [
      _english,
      _hungarian,
      _ipa,
      _notes,
      _trapNote,
      _newExample,
      _newExampleSecond,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  bool get _hasExamples => _type != ItemType.sentence;
  bool get _canSave => _loaded && _english.text.trim().isNotEmpty && !_saving;

  /// A félig beírt (még nem hozzáadott) példát is beleszámoljuk.
  int get _pendingExample => _newExample.text.trim().isNotEmpty ? 1 : 0;

  int get _xp {
    if (!_hasExamples) return _isEditing ? 0 : XpRules.forNewItem(_type);
    if (_isEditing) {
      // Szerkesztéskor csak az újonnan létrejövő példamondatokért jár XP.
      final created = _examples.where((e) => e.createsSentence).length;
      return XpRules.perExample * (created + _pendingExample);
    }
    return XpRules.forNewItem(_type, exampleCount: _examples.length + _pendingExample);
  }

  void _flushPendingExample() {
    final english = _newExample.text.trim();
    if (english.isEmpty) return;
    final second = _newExampleSecond.text.trim();
    _examples = [
      ..._examples,
      ExampleDraft(english: english, second: second.isEmpty ? null : second),
    ];
    _newExample.clear();
    _newExampleSecond.clear();
  }

  NewItem _buildDraft() {
    final isRule = _type == ItemType.rule;
    final examples = _hasExamples ? _examples : const <ExampleDraft>[];
    return NewItem(
      type: _type,
      english: _english.text,
      hungarian: isRule ? '' : _hungarian.text,
      notes: _type == ItemType.sentence ? null : _notes.text,
      partOfSpeech: _type == ItemType.word ? _partOfSpeech : null,
      ipa: _type == ItemType.word ? _ipa.text : null,
      phraseKind: _type == ItemType.phrase ? _phraseKind : null,
      level: _level,
      source: _source,
      ruleCategory: isRule ? _ruleCategory : null,
      formula: isRule ? _formula : const [],
      trapNote: isRule && _showTrapNote ? _trapNote.text : null,
      tags: _tags,
      examples: [
        for (final e in examples)
          if (e.isCorrect) NewExample(e.english, hungarian: e.second, existingId: e.sentenceId),
      ],
      mistakes: [
        if (isRule)
          for (final e in examples)
            if (!e.isCorrect) NewMistake(e.english, explanation: e.second),
      ],
    );
  }

  Future<void> _save() async {
    if (!_canSave) return;
    final xp = _xp;
    setState(() {
      _saving = true;
      _flushPendingExample();
    });

    try {
      final items = ref.read(itemsRepositoryProvider);
      final xpRepository = ref.read(xpRepositoryProvider);

      if (_isEditing) {
        final id = widget.editItemId!;
        final created = await items.updateItem(id, _buildDraft());
        final earned = created * XpRules.perExample;
        if (earned > 0) {
          await xpRepository.award(earned, XpReason.addExample, itemId: id);
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(earned > 0 ? 'Changes saved · +$earned XP' : 'Changes saved')),
        );
        // Vissza a részletre – az élő streamből magától frissül.
        context.pop();
        return;
      }

      final id = await items.createItem(_buildDraft());
      await xpRepository.award(xp, XpReason.addItem, itemId: id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Saved to your box · +$xp XP')));
      context.pushReplacement('/item/$id');
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save: $error')));
    }
  }

  Future<void> _editRuleCategory() async {
    final input = await showTextInputDialog(
      context,
      title: 'Rule group',
      initial: _ruleCategory ?? '',
      hint: 'e.g. Conditionals, Tenses',
    );
    if (input != null) {
      setState(() => _ruleCategory = input.isEmpty ? null : input);
    }
  }

  // ------------------------------------------------------------------ UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(
              title: _isEditing
                  ? (_loaded ? 'Edit ${_type.label.toLowerCase()}' : '')
                  : _type.newTitle,
              onLeading: () => context.pop(),
            ),
            Expanded(
              child: _missing
                  ? const Center(
                      child: Text(
                        'This item is no longer in your box.',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    )
                  : !_loaded
                  ? const Center(child: CircularProgressIndicator())
                  : _form(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: !_loaded
          ? null
          : _SaveBar(
              label: _isEditing
                  ? 'Save changes'
                  : (_type == ItemType.rule ? 'Save rule' : 'Save to box'),
              badge: _xp > 0 ? '+$_xp XP' : null,
              onPressed: _canSave ? _save : null,
            ),
    );
  }

  Widget _form() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 18,
        children: [
          // Szerkesztéskor a típus nem változtatható.
          if (!_isEditing)
            TypeSelector(value: _type, onChanged: (type) => setState(() => _type = type)),
          ..._typeSpecificFields(),
          if (_hasExamples)
            ExamplesEditor(
              type: _type,
              term: _english.text,
              examples: _examples,
              onChanged: (list) => setState(() => _examples = list),
              newEnglish: _newExample,
              newSecond: _newExampleSecond,
              editing: _isEditing,
            ),
          LevelPicker(value: _level, onChanged: (level) => setState(() => _level = level)),
          TagsSourceRow(
            tags: _tags,
            onTagsChanged: (tags) => setState(() => _tags = tags),
            source: _source,
            onSourceChanged: (source) => setState(() => _source = source),
          ),
        ],
      ),
    );
  }

  List<Widget> _typeSpecificFields() {
    return switch (_type) {
      ItemType.word => [
        _mainField(),
        IpaField(
          controller: _ipa,
          color: _type.color,
          background: _type.background,
          onListen: _english.text.trim().isEmpty
              ? null
              : () => ref.read(speechServiceProvider).speak(_english.text.trim()),
        ),
        _labeled('Meaning in Hungarian', _textField(_hungarian, hint: 'vonakodó, kelletlen')),
        _labeled(
          'Part of speech',
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final pos in PartOfSpeech.values)
                _typeChip(
                  pos.label,
                  _partOfSpeech == pos,
                  () => setState(() => _partOfSpeech = _partOfSpeech == pos ? null : pos),
                ),
            ],
          ),
        ),
        NotesEditor(
          controller: _notes,
          color: _type.color,
          hint: 'Anything worth remembering: usage, word family, look-alikes…',
        ),
      ],
      ItemType.phrase => [
        _mainField(),
        _labeled(
          'Kind',
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final kind in PhraseKind.values)
                _typeChip(
                  kind.label,
                  _phraseKind == kind,
                  () => setState(() => _phraseKind = _phraseKind == kind ? null : kind),
                ),
            ],
          ),
        ),
        _labeled('Meaning in Hungarian', _textField(_hungarian, hint: 'egy hullámhosszon vagyunk')),
        NotesEditor(controller: _notes, color: _type.color, hint: 'When and how to use it…'),
      ],
      ItemType.rule => [
        _labeled(
          _type.englishLabel,
          _englishField(),
          trailing: TextButton.icon(
            onPressed: _editRuleCategory,
            icon: const Icon(Icons.expand_more_rounded, size: 16),
            iconAlignment: IconAlignment.end,
            label: Text(_ruleCategory ?? 'Group'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.rule,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              textStyle: const TextStyle(
                fontFamily: 'Lexend',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        FormulaEditor(blocks: _formula, onChanged: (blocks) => setState(() => _formula = blocks)),
        _labeled(
          'Explanation',
          _textField(
            _notes,
            hint: 'When do we use it? How is it built?',
            minLines: 6,
            maxLines: 14,
          ),
        ),
        if (_showTrapNote)
          _labeled(
            'Hungarian trap note',
            _textField(
              _trapNote,
              hint: 'What do Hungarians often get wrong?',
              minLines: 2,
              maxLines: 5,
            ),
          )
        else
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => setState(() => _showTrapNote = true),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.rule,
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('+ Add a Hungarian trap note'),
            ),
          ),
      ],
      ItemType.sentence => [
        _mainField(minLines: 2, maxLines: 4, fontSize: 18),
        _labeled('Translation', _textField(_hungarian, hint: 'Végigvezetnél az új folyamaton?')),
      ],
    };
  }

  Widget _mainField({int minLines = 1, int maxLines = 1, double fontSize = 22}) => _labeled(
    _type.englishLabel,
    _englishField(minLines: minLines, maxLines: maxLines, fontSize: fontSize),
  );

  /// A fő angol mező – keretszíne az elemtípus színe.
  Widget _englishField({int minLines = 1, int maxLines = 1, double fontSize = 20}) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.button),
      borderSide: BorderSide(color: _type.color, width: 2),
    );
    return TextField(
      controller: _english,
      autofocus: !_isEditing && widget.initialText.isEmpty,
      minLines: minLines,
      maxLines: maxLines,
      textCapitalization: _type == ItemType.sentence
          ? TextCapitalization.sentences
          : TextCapitalization.none,
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700),
      decoration: InputDecoration(enabledBorder: border, focusedBorder: border),
    );
  }

  Widget _textField(
    TextEditingController controller, {
    String? hint,
    int minLines = 1,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 16, height: 1.5),
      decoration: InputDecoration(hintText: hint),
    );
  }

  Widget _labeled(String label, Widget child, {Widget? trailing}) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 6,
    children: [
      FieldLabel(label, trailing: trailing),
      child,
    ],
  );

  Widget _typeChip(String label, bool selected, VoidCallback onTap) => SelectChip(
    label: label,
    selected: selected,
    onTap: onTap,
    color: _type.color,
    selectedBackground: _type.background,
  );
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.label, required this.badge, required this.onPressed});

  final String label;
  final String? badge;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.surfaceAlt)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.paddingOf(context).bottom),
      child: ChunkyButton(label: label, badge: badge, onPressed: onPressed),
    );
  }
}

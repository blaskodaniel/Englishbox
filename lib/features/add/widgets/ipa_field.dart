import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../widgets/field_label.dart';

/// Kiejtés (IPA) mező: szövegmező + meghallgatás gomb + gyorsbillentyűk a
/// telefonbillentyűzeten nem elérhető IPA-jelekhez.
class IpaField extends StatefulWidget {
  const IpaField({
    super.key,
    required this.controller,
    required this.onListen,
    this.color = AppColors.word,
    this.background = AppColors.wordBg,
  });

  final TextEditingController controller;

  /// `null` → a gomb letiltva (pl. még nincs beírva angol szó).
  final VoidCallback? onListen;
  final Color color;
  final Color background;

  @override
  State<IpaField> createState() => _IpaFieldState();
}

class _IpaFieldState extends State<IpaField> {
  /// A leggyakoribbak – ezek mindig látszanak (a terv sorrendjében).
  static const _common = ['ˈ', 'ː', 'ə', 'ɪ', 'æ', 'ʌ', 'θ', 'ð', 'ʃ', 'ŋ'];

  /// A „…” gombbal kinyíló további jelek.
  static const _more = [
    '/', 'ˌ', 'ɑ', 'ɒ', 'ɔ', 'ɜ', 'ʊ', 'ɛ', 'e', 'i', 'u', //
    'ʒ', 'tʃ', 'dʒ', 'j', 'r', 'ɹ', 'ɡ', 'ɾ', 'ʔ',
    'eɪ', 'aɪ', 'ɔɪ', 'əʊ', 'oʊ', 'aʊ', 'ɪə', 'eə', 'ʊə',
  ];

  bool _expanded = false;

  /// A kurzor helyére szúrja be a jelet (a kijelölt szöveget lecseréli) –
  /// mint egy `input.setRangeText()` a weben.
  void _insert(String symbol) {
    final controller = widget.controller;
    final value = controller.value;
    final selection = value.selection.isValid
        ? value.selection
        : TextSelection.collapsed(offset: value.text.length);
    final text = value.text.replaceRange(selection.start, selection.end, symbol);
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: selection.start + symbol.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final symbols = [..._common, if (_expanded) ..._more];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        const FieldLabel('Pronunciation (IPA) · optional'),
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                autocorrect: false,
                enableSuggestions: false,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(hintText: '/rɪˈlʌktənt/'),
              ),
            ),
            SizedBox.square(
              dimension: 50,
              child: IconButton(
                tooltip: 'Listen',
                onPressed: widget.onListen,
                style: IconButton.styleFrom(
                  backgroundColor: widget.background,
                  foregroundColor: widget.color,
                  disabledBackgroundColor: AppColors.surfaceAlt,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.volume_up_rounded, size: 22),
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final symbol in symbols) _SymbolKey(label: symbol, onTap: () => _insert(symbol)),
            _SymbolKey(
              label: _expanded ? '‹' : '…',
              tooltip: _expanded ? 'Fewer symbols' : 'More symbols',
              color: widget.color,
              onTap: () => setState(() => _expanded = !_expanded),
            ),
          ],
        ),
      ],
    );
  }
}

class _SymbolKey extends StatelessWidget {
  const _SymbolKey({
    required this.label,
    required this.onTap,
    this.tooltip,
    this.color = AppColors.text,
  });

  final String label;
  final VoidCallback onTap;
  final String? tooltip;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final key = Material(
      color: AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Center(
              widthFactor: 1,
              child: Text(label, style: TextStyle(fontSize: 16, color: color)),
            ),
          ),
        ),
      ),
    );
    return tooltip == null ? key : Tooltip(message: tooltip, child: key);
  }
}

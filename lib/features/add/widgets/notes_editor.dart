import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme.dart';
import '../../../domain/note_markup.dart';
import '../../../widgets/field_label.dart';

/// „Notes · optional” – többsoros jegyzetmező egy kis formázó eszköztárral
/// (félkövér, dőlt, felsorolás, kiemelés), a terv szerint.
///
/// A gombok jelölőket szúrnak be a szövegbe (`**…**`, `_…_`, `==…==`, `• `),
/// a részletező oldal ezekből rajzolja ki a formázást.
class NotesEditor extends StatefulWidget {
  const NotesEditor({
    super.key,
    required this.controller,
    required this.color,
    this.label = 'Notes · optional',
    this.hint,
  });

  final TextEditingController controller;

  /// Az elemtípus színe: fókuszált keret és a kiemelés gomb.
  final Color color;
  final String label;
  final String? hint;

  @override
  State<NotesEditor> createState() => _NotesEditorState();
}

class _NotesEditorState extends State<NotesEditor> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    // A keret színe a fókusztól, a felsorolás gomb állapota a kurzortól függ.
    _focus.addListener(_refresh);
    widget.controller.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    _focus.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  TextSelection get _selection {
    final value = widget.controller.value;
    return value.selection.isValid
        ? value.selection
        : TextSelection.collapsed(offset: value.text.length);
  }

  /// A kijelölést jelölők közé teszi; kijelölés nélkül a kurzor a jelölők
  /// közé kerül, így rögtön lehet gépelni.
  void _wrap(String marker) {
    final value = widget.controller.value;
    final selection = _selection;
    final selected = selection.textInside(value.text);
    final start = selection.start + marker.length;
    widget.controller.value = TextEditingValue(
      text: value.text.replaceRange(selection.start, selection.end, '$marker$selected$marker'),
      selection: selected.isEmpty
          ? TextSelection.collapsed(offset: start)
          : TextSelection(baseOffset: start, extentOffset: start + selected.length),
    );
    _focus.requestFocus();
  }

  /// A kijelölt sor(ok) eleje: (első sor kezdete, utolsó sor vége).
  (int, int) _lineRange() {
    final text = widget.controller.text;
    final selection = _selection;
    final start = selection.start == 0 ? 0 : text.lastIndexOf('\n', selection.start - 1) + 1;
    final end = text.indexOf('\n', selection.end);
    return (start, end == -1 ? text.length : end);
  }

  bool get _inList {
    final (start, end) = _lineRange();
    return widget.controller.text.substring(start, end).startsWith(bulletPrefix);
  }

  /// Felsorolás be/ki az érintett sorokon.
  void _toggleBullets() {
    final value = widget.controller.value;
    final selection = _selection;
    final (start, end) = _lineRange();
    final lines = value.text.substring(start, end).split('\n');
    final remove = lines.every((l) => l.startsWith(bulletPrefix));
    final changed = [
      for (final line in lines)
        remove
            ? line.substring(bulletPrefix.length)
            : line.startsWith(bulletPrefix)
            ? line
            : '$bulletPrefix$line',
    ].join('\n');

    final TextSelection newSelection;
    if (selection.isCollapsed) {
      final shift = changed.length - (end - start);
      newSelection = TextSelection.collapsed(
        offset: (selection.start + shift).clamp(start, start + changed.length),
      );
    } else {
      newSelection = TextSelection(baseOffset: start, extentOffset: start + changed.length);
    }
    widget.controller.value = TextEditingValue(
      text: value.text.replaceRange(start, end, changed),
      selection: newSelection,
    );
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        FieldLabel(widget.label),
        AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.input,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: focused ? widget.color : AppColors.borderStrong, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // A TextFieldTapRegion miatt a gombok a mező „részének” számítanak:
              // rájuk koppintva nem vész el a fókusz és a kijelölés.
              TextFieldTapRegion(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.borderStrong)),
                  ),
                  child: Row(
                    spacing: 4,
                    children: [
                      _ToolButton(
                        tooltip: 'Bold',
                        onTap: () => _wrap('**'),
                        child: const Text(
                          'B',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                      ),
                      _ToolButton(
                        tooltip: 'Italic',
                        onTap: () => _wrap('_'),
                        child: const Text(
                          'I',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      _ToolButton(
                        tooltip: 'Bullet list',
                        active: _inList,
                        onTap: _toggleBullets,
                        child: const Icon(Icons.format_list_bulleted_rounded, size: 19),
                      ),
                      _ToolButton(
                        tooltip: 'Highlight',
                        color: widget.color,
                        onTap: () => _wrap('=='),
                        child: const Icon(Icons.border_color_outlined, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
              TextField(
                controller: widget.controller,
                focusNode: _focus,
                minLines: 5,
                maxLines: 12,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: [_BulletContinuation()],
                style: const TextStyle(fontSize: 15, height: 1.55),
                // Saját keret van körülötte, a mezőé kikapcsolva.
                decoration: InputDecoration(
                  hintText: widget.hint,
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.tooltip,
    required this.onTap,
    required this.child,
    this.active = false,
    this.color = AppColors.textSoft,
  });

  final String tooltip;
  final VoidCallback onTap;
  final Widget child;
  final bool active;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: active ? AppColors.surfaceAlt : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: SizedBox.square(
            dimension: 36,
            child: Center(
              child: IconTheme.merge(
                data: IconThemeData(color: active ? AppColors.text : color),
                child: DefaultTextStyle.merge(
                  style: TextStyle(color: active ? AppColors.text : color),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Felsorolásban az Enter új „• ” sort kezd; üres pontnál Enter → vége a listának.
/// (Mint egy szövegszerkesztő – a `TextInputFormatter` minden gépelésnél lefut,
/// mint egy `onChange`, ami még a mentés előtt átírhatja az értéket.)
class _BulletContinuation extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final selection = newValue.selection;
    if (!selection.isCollapsed || text.length != oldValue.text.length + 1) return newValue;
    final position = selection.baseOffset;
    if (position <= 0 || text[position - 1] != '\n') return newValue;

    final lineStart = position < 2 ? 0 : text.lastIndexOf('\n', position - 2) + 1;
    final line = text.substring(lineStart, position - 1);
    if (!line.startsWith(bulletPrefix)) return newValue;

    if (line.trim() == bulletPrefix.trim()) {
      // Üres pont: a „• ” és az új sor is törlődik, a lista véget ér.
      return TextEditingValue(
        text: text.replaceRange(lineStart, position, ''),
        selection: TextSelection.collapsed(offset: lineStart),
      );
    }
    return TextEditingValue(
      text: text.replaceRange(position, position, bulletPrefix),
      selection: TextSelection.collapsed(offset: position + bulletPrefix.length),
    );
  }
}

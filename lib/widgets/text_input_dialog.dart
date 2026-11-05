import 'package:flutter/material.dart';

/// Egyszerű párbeszédablak egy szövegmezővel. A beírt (trimelt) szöveget adja vissza,
/// vagy `null`-t, ha a felhasználó megszakította.
Future<String?> showTextInputDialog(
  BuildContext context, {
  required String title,
  String initial = '',
  String? hint,
  String confirmLabel = 'OK',
}) {
  return showDialog<String>(
    context: context,
    builder: (context) =>
        _TextInputDialog(title: title, initial: initial, hint: hint, confirmLabel: confirmLabel),
  );
}

class _TextInputDialog extends StatefulWidget {
  const _TextInputDialog({
    required this.title,
    required this.initial,
    required this.hint,
    required this.confirmLabel,
  });

  final String title;
  final String initial;
  final String? hint;
  final String confirmLabel;

  @override
  State<_TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text.trim());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(hintText: widget.hint),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        TextButton(onPressed: _submit, child: Text(widget.confirmLabel)),
      ],
    );
  }
}

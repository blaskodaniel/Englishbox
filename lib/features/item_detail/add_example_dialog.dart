import 'package:flutter/material.dart';

import '../../domain/drafts.dart';

/// Saját példamondat bekérése. `null`, ha a felhasználó megszakította.
Future<NewExample?> showAddExampleDialog(BuildContext context, {required String term}) {
  return showDialog<NewExample>(
    context: context,
    builder: (_) => _AddExampleDialog(term: term),
  );
}

class _AddExampleDialog extends StatefulWidget {
  const _AddExampleDialog({required this.term});

  final String term;

  @override
  State<_AddExampleDialog> createState() => _AddExampleDialogState();
}

class _AddExampleDialogState extends State<_AddExampleDialog> {
  final _english = TextEditingController();
  final _hungarian = TextEditingController();

  @override
  void initState() {
    super.initState();
    _english.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _english.dispose();
    _hungarian.dispose();
    super.dispose();
  }

  void _submit() {
    final english = _english.text.trim();
    if (english.isEmpty) return;
    final hungarian = _hungarian.text.trim();
    Navigator.of(context).pop(
      NewExample(english, hungarian: hungarian.isEmpty ? null : hungarian),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Your own example'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          TextField(
            controller: _english,
            autofocus: true,
            minLines: 1,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(hintText: 'A sentence with „${widget.term}”…'),
          ),
          TextField(
            controller: _hungarian,
            decoration: const InputDecoration(hintText: 'Hungarian translation (optional)'),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _english.text.trim().isEmpty ? null : _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}

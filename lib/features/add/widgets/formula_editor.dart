import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../domain/formula.dart';
import '../../../widgets/field_label.dart';

/// Nyelvtani képlet szerkesztése blokkokból: `If` + `past simple` + `would` + `verb`.
class FormulaEditor extends StatelessWidget {
  const FormulaEditor({super.key, required this.blocks, required this.onChanged});

  final List<FormulaBlock> blocks;
  final ValueChanged<List<FormulaBlock>> onChanged;

  Future<void> _addBlock(BuildContext context) async {
    final block = await showDialog<FormulaBlock>(
      context: context,
      builder: (_) => const _NewBlockDialog(),
    );
    if (block != null) onChanged([...blocks, block]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        FieldLabel(
          blocks.isEmpty ? 'Formula · tap + to add a block' : 'Formula · tap a block to remove it',
        ),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final (index, block) in blocks.indexed)
              Semantics(
                button: true,
                label: 'Remove block ${block.text}',
                child: GestureDetector(
                  onTap: () => onChanged([...blocks]..removeAt(index)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                    decoration: BoxDecoration(
                      color: block.isKeyword ? AppColors.rule : AppColors.ruleSlot,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      block.text,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: block.isKeyword ? FontWeight.w700 : FontWeight.w600,
                        color: block.isKeyword ? AppColors.onRule : AppColors.text,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox.square(
              dimension: 38,
              child: IconButton(
                tooltip: 'Add formula block',
                onPressed: () => _addBlock(context),
                icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.rule),
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: AppColors.ruleSoft, width: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NewBlockDialog extends StatefulWidget {
  const _NewBlockDialog();

  @override
  State<_NewBlockDialog> createState() => _NewBlockDialogState();
}

class _NewBlockDialogState extends State<_NewBlockDialog> {
  final _controller = TextEditingController();
  bool _isKeyword = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    Navigator.of(context).pop(text.isEmpty ? null : FormulaBlock(text, isKeyword: _isKeyword));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Formula block'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'e.g. would, past simple'),
            onSubmitted: (_) => _submit(),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Keyword'),
            subtitle: const Text('Fixed word like „If” or „would”'),
            value: _isKeyword,
            onChanged: (value) => setState(() => _isKeyword = value),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        TextButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}

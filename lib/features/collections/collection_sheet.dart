import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../data/db.dart';
import '../../data/providers.dart';
import '../../widgets/chunky_button.dart';
import '../../widgets/field_label.dart';
import 'collection_style.dart';

/// Új gyűjtemény létrehozása, vagy egy meglévő ([existing]) szerkesztése/törlése.
/// Létrehozáskor az új gyűjtemény azonosítójával tér vissza.
Future<int?> showCollectionSheet(BuildContext context, {Collection? existing}) {
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true, // a billentyűzet fölé tudjon nőni
    showDragHandle: true,
    builder: (_) => _CollectionSheet(existing: existing),
  );
}

class _CollectionSheet extends ConsumerStatefulWidget {
  const _CollectionSheet({this.existing});

  final Collection? existing;

  @override
  ConsumerState<_CollectionSheet> createState() => _CollectionSheetState();
}

class _CollectionSheetState extends ConsumerState<_CollectionSheet> {
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late String _icon = widget.existing?.icon ?? collectionIcons.keys.first;
  late Color _color = widget.existing?.colorValue ?? collectionColors.first;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final repository = ref.read(collectionsRepositoryProvider);
    final navigator = Navigator.of(context);
    final existing = widget.existing;
    if (existing != null) {
      await repository.update(existing.id, name: name, icon: _icon, color: _color.toARGB32());
      navigator.pop(existing.id);
    } else {
      final id = await repository.create(name: name, icon: _icon, color: _color.toARGB32());
      navigator.pop(id);
    }
  }

  Future<void> _delete() async {
    final existing = widget.existing!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete „${existing.name}”?'),
        content: const Text('The items stay in your box – only the collection is removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.wrong),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final navigator = Navigator.of(context);
    await ref.read(collectionsRepositoryProvider).delete(existing.id);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    // A billentyűzet magassága – ennyivel feljebb toljuk a lapot.
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + keyboard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 18,
          children: [
            Row(
              spacing: 14,
              children: [
                CollectionBadge(icon: _icon, color: _color),
                Expanded(
                  child: Text(
                    _isEditing ? 'Edit collection' : 'New collection',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                if (_isEditing)
                  IconButton(
                    tooltip: 'Delete collection',
                    onPressed: _delete,
                    icon: const Icon(Icons.delete_outline_rounded, color: AppColors.wrong),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                const FieldLabel('Name'),
                TextField(
                  controller: _name,
                  autofocus: !_isEditing,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _save(),
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(hintText: 'e.g. Work English, Series & films'),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                const FieldLabel('Icon'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final MapEntry(:key, :value) in collectionIcons.entries)
                      _Choice(
                        selected: _icon == key,
                        color: _color,
                        label: key,
                        onTap: () => setState(() => _icon = key),
                        child: Icon(
                          value,
                          size: 22,
                          color: _icon == key ? _color : AppColors.textSoft,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                const FieldLabel('Colour'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final color in collectionColors)
                      _Choice(
                        selected: _color == color,
                        color: color,
                        label: 'colour',
                        onTap: () => setState(() => _color = color),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            ChunkyButton(
              label: _isEditing ? 'Save changes' : 'Create collection',
              onPressed: _name.text.trim().isEmpty ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}

/// 48×48-as választógomb; kiválasztva a megadott színnel keretezett.
class _Choice extends StatelessWidget {
  const _Choice({
    required this.selected,
    required this.color,
    required this.label,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final Color color;
  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: selected ? collectionBackground(color) : AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? color : Colors.transparent, width: 2),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

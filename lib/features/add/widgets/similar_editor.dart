import 'package:flutter/material.dart';

import '../../../app/labels.dart';
import '../../../app/theme.dart';
import '../../../data/db.dart';
import '../../../domain/enums.dart';
import '../../../widgets/field_label.dart';
import '../../../widgets/item_picker_sheet.dart';

/// „Similar · optional” – hasonló szavak/kifejezések összekötése (pl. „get over”
/// ↔ „recover from”). Chipek × gombbal + „Link similar” a dobozból választáshoz.
///
/// Kontrollált komponens: a listát a szülő tartja ([items] + [onChanged]).
class SimilarEditor extends StatelessWidget {
  const SimilarEditor({
    super.key,
    required this.items,
    required this.onChanged,
    required this.color,
    this.selfId,
  });

  final List<Item> items;
  final ValueChanged<List<Item>> onChanged;
  final Color color;

  /// Szerkesztéskor maga az elem – önmagához nem köthető.
  final int? selfId;

  Future<void> _pick(BuildContext context) async {
    final picked = await showItemPickerSheet(
      context,
      title: 'Link similar words',
      types: const {ItemType.word, ItemType.phrase},
      excludeIds: {?selfId, for (final i in items) i.id},
      confirmLabel: 'Link',
    );
    if (picked == null || picked.isEmpty) return;
    onChanged([...items, ...picked]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        const FieldLabel('Similar · optional'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final item in items)
              InputChip(
                label: Text(item.english),
                avatar: CircleAvatar(radius: 4, backgroundColor: item.type.color),
                onDeleted: () => onChanged([...items]..removeWhere((i) => i.id == item.id)),
                deleteButtonTooltipMessage: 'Unlink',
                backgroundColor: AppColors.surfaceAlt,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.chip)),
              ),
            ActionChip(
              avatar: Icon(Icons.add_rounded, size: 18, color: color),
              label: Text('Link similar', style: TextStyle(color: color)),
              onPressed: () => _pick(context),
              backgroundColor: Colors.transparent,
              side: const BorderSide(color: AppColors.borderStrong, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.chip)),
            ),
          ],
        ),
      ],
    );
  }
}

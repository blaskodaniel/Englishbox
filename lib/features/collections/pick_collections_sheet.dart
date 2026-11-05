import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../data/providers.dart';
import 'collection_sheet.dart';
import 'collection_style.dart';

/// Az elemrészletről: melyik gyűjteményekben legyen benne az elem.
/// Minden koppintás azonnal mentődik (nincs külön „Mentés” gomb).
Future<void> showPickCollectionsSheet(BuildContext context, {required int itemId}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _PickCollectionsSheet(itemId: itemId),
  );
}

class _PickCollectionsSheet extends ConsumerWidget {
  const _PickCollectionsSheet({required this.itemId});

  final int itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider).value ?? const [];
    final memberOf = ref.watch(itemCollectionIdsProvider(itemId)).value ?? const <int>{};
    final repository = ref.read(collectionsRepositoryProvider);

    Future<void> createAndAdd() async {
      final id = await showCollectionSheet(context);
      if (id != null) await repository.setMembership(id, itemId, member: true);
    }

    return SafeArea(
      child: ConstrainedBox(
        // Legfeljebb a képernyő ~70%-a, utána görgethető.
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Text(
                'Add to collections',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            for (final summary in collections)
              CheckboxListTile(
                value: memberOf.contains(summary.collection.id),
                onChanged: (checked) => repository.setMembership(
                  summary.collection.id,
                  itemId,
                  member: checked ?? false,
                ),
                activeColor: AppColors.accent,
                checkColor: AppColors.onAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                secondary: CollectionBadge(
                  icon: summary.collection.icon,
                  color: summary.collection.colorValue,
                  size: 40,
                ),
                title: Text(
                  summary.collection.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  summary.total == 1 ? '1 item' : '${summary.total} items',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ),
            ListTile(
              onTap: createAndAdd,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: AppColors.dashed, width: 2),
                ),
                child: const Icon(Icons.add_rounded, color: AppColors.accent),
              ),
              title: const Text(
                'New collection',
                style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

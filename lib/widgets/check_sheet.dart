import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/theme.dart';
import '../data/db.dart';
import '../data/providers.dart';
import 'chunky_button.dart';

/// „To check” jelölés: megjelölöd az elemet, hogy később utánanézz.
/// Opcionálisan leírhatod, mi a kérdés („mikor on, mikor in?”).
///
/// Ha az elem már meg van jelölve, a megjegyzés szerkeszthető, és a jelölés
/// levehető („Done – I checked it”).
Future<void> showCheckSheet(BuildContext context, Item item) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true, // a billentyűzet fölé tudjon nőni
    showDragHandle: true,
    builder: (_) => _CheckSheet(item: item),
  );
}

class _CheckSheet extends ConsumerStatefulWidget {
  const _CheckSheet({required this.item});

  final Item item;

  @override
  ConsumerState<_CheckSheet> createState() => _CheckSheetState();
}

class _CheckSheetState extends ConsumerState<_CheckSheet> {
  late final _note = TextEditingController(text: widget.item.checkNote ?? '');

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save({required bool needsCheck}) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    await ref
        .read(itemsRepositoryProvider)
        .setNeedsCheck(widget.item.id, needsCheck: needsCheck, note: _note.text);
    navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(needsCheck ? 'Marked to check' : 'Check mark removed'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flagged = widget.item.needsCheck;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + keyboard),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 14,
          children: [
            Row(
              spacing: 12,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.wrongBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.flag_rounded, color: AppColors.wrong),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        flagged ? 'Marked to check' : 'Mark to check later',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        widget.item.english,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            TextField(
              controller: _note,
              autofocus: !flagged,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: "What's unclear? (optional) – e.g. „on or in?”",
              ),
            ),
            const Text(
              'You’ll find it in Library → items to check.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            ChunkyButton(
              label: flagged ? 'Save note' : 'Mark to check',
              icon: Icons.flag_rounded,
              onPressed: () => _save(needsCheck: true),
            ),
            if (flagged)
              OutlinedButton.icon(
                onPressed: () => _save(needsCheck: false),
                icon: const Icon(Icons.check_rounded, size: 18),
                label: const Text('Done – I checked it'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: AppColors.borderStrong, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

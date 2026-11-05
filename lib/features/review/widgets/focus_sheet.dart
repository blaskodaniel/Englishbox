import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../data/providers.dart';
import '../../../domain/enums.dart';
import '../../../widgets/field_label.dart';
import '../../../widgets/select_chip.dart';
import '../review_providers.dart';

Future<void> showReviewFocusSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _FocusSheet(),
  );
}

/// Csak egy szint és/vagy egy címke elemeit ismételjük.
class _FocusSheet extends ConsumerWidget {
  const _FocusSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focus = ref.watch(reviewFocusProvider);
    final notifier = ref.read(reviewFocusProvider.notifier);
    final tags = ref.watch(tagsWithCountsProvider).value ?? const [];

    Widget section(String title, List<Widget> chips) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        FieldLabel(title),
        Wrap(spacing: 8, runSpacing: 8, children: chips),
      ],
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 18,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Focus', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                if (!focus.isEmpty)
                  TextButton(onPressed: notifier.clear, child: const Text('Clear')),
              ],
            ),
            section('Level', [
              for (final level in CefrLevel.values)
                SelectChip(
                  label: level.label,
                  selected: focus.level == level,
                  onTap: () => notifier.setLevel(focus.level == level ? null : level),
                ),
            ]),
            section(
              'Tag',
              tags.isEmpty
                  ? [const Text('No tags yet', style: TextStyle(color: AppColors.textMuted))]
                  : [
                      for (final t in tags)
                        SelectChip(
                          label: '#${t.tag.name}',
                          selected: focus.tagId == t.tag.id,
                          onTap: () => focus.tagId == t.tag.id
                              ? notifier.setTag(null, null)
                              : notifier.setTag(t.tag.id, t.tag.name),
                        ),
                    ],
            ),
          ],
        ),
      ),
    );
  }
}

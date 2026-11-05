import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../data/repositories/items_repository.dart' show normalizeTag;
import '../../../widgets/text_input_dialog.dart';

/// Címkék (#work…) és a forrás („Source: lesson”) egy sorban.
class TagsSourceRow extends StatelessWidget {
  const TagsSourceRow({
    super.key,
    required this.tags,
    required this.onTagsChanged,
    required this.source,
    required this.onSourceChanged,
  });

  final List<String> tags;
  final ValueChanged<List<String>> onTagsChanged;
  final String? source;
  final ValueChanged<String?> onSourceChanged;

  Future<void> _addTag(BuildContext context) async {
    final input = await showTextInputDialog(
      context,
      title: 'New tag',
      hint: 'e.g. work, travel',
      confirmLabel: 'Add',
    );
    if (input == null) return;
    final name = normalizeTag(input);
    if (name.isEmpty || tags.contains(name)) return;
    onTagsChanged([...tags, name]);
  }

  Future<void> _editSource(BuildContext context) async {
    final input = await showTextInputDialog(
      context,
      title: 'Where did you find it?',
      initial: source ?? '',
      hint: 'e.g. lesson, work call, a series',
    );
    if (input == null) return;
    onSourceChanged(input.isEmpty ? null : input);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tag in tags)
          _Pill(
            onTap: () => onTagsChanged([...tags]..remove(tag)),
            semanticLabel: 'Remove tag $tag',
            children: [
              Text('#$tag'),
              const Icon(Icons.close_rounded, size: 14, color: AppColors.textMuted),
            ],
          ),
        _Pill(
          onTap: () => _addTag(context),
          semanticLabel: 'Add tag',
          children: const [
            Icon(Icons.add_rounded, size: 14, color: AppColors.textMuted),
            Text('tag', style: TextStyle(color: AppColors.textMuted)),
          ],
        ),
        _Pill(
          onTap: () => _editSource(context),
          outlined: true,
          semanticLabel: 'Edit source',
          children: [
            Text(
              source == null ? '+ Source' : 'Source: $source',
              style: const TextStyle(color: AppColors.textSoft),
            ),
          ],
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.onTap,
    required this.children,
    required this.semanticLabel,
    this.outlined = false,
  });

  final VoidCallback onTap;
  final List<Widget> children;
  final String semanticLabel;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: outlined ? Colors.transparent : AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadii.chip),
            border: outlined ? Border.all(color: AppColors.borderStrong, width: 2) : null,
          ),
          child: DefaultTextStyle.merge(
            style: const TextStyle(fontSize: 14),
            child: Row(mainAxisSize: MainAxisSize.min, spacing: 6, children: children),
          ),
        ),
      ),
    );
  }
}

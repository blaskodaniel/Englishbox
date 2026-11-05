import 'package:flutter/material.dart';

import '../../../app/theme.dart';

/// Nagybetűs szekciócím + kártya.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.padded = true,
    this.footer,
  });

  final String title;
  final List<Widget> children;

  /// `false` → a sorok maguk adják a belső margót (kapcsolós / gombos sorok).
  final bool padded;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: AppColors.textMuted,
          ),
        ),
        Container(
          padding: padded ? const EdgeInsets.all(16) : EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: padded ? 16 : 0,
            children: padded ? children : _withDividers(children),
          ),
        ),
        if (footer != null)
          Text(
            footer!,
            style: const TextStyle(fontSize: 12, height: 1.5, color: AppColors.textMuted),
          ),
      ],
    );
  }

  static List<Widget> _withDividers(List<Widget> rows) => [
    for (final (i, row) in rows.indexed) ...[if (i > 0) const Divider(height: 1), row],
  ];
}

/// Felirat + alatta a vezérlő (pl. szegmensválasztó).
class LabeledSetting extends StatelessWidget {
  const LabeledSetting({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        child,
      ],
    );
  }
}

/// Egy sor: cím, alcím, jobbra egy vezérlő (kapcsoló, idő, nyíl).
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          spacing: 12,
          children: [
            ?leading,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                    ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

/// Kapcsolós sor.
class SwitchRow extends StatelessWidget {
  const SwitchRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: SettingsRow(
        title: title,
        subtitle: subtitle,
        onTap: () => onChanged(!value),
        trailing: Switch(value: value, onChanged: onChanged),
      ),
    );
  }
}

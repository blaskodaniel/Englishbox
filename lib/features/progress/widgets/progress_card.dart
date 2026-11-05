import 'package:flutter/material.dart';

import '../../../app/theme.dart';

/// Keretes kártya címmel és jobbra egy halvány összesítővel („31 total”).
class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key, required this.title, required this.child, this.trailing});

  final String title;
  final String? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.panel),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              if (trailing != null)
                Text(trailing!, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
            ],
          ),
          child,
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Ideiglenes képernyő, amíg a valódi el nem készül.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    this.links = const {},
    this.showAppBar = false,
  });

  final String title;

  /// Gombfelirat -> útvonal, a navigáció kipróbálásához.
  final Map<String, String> links;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar(title: Text(title)) : null,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              for (final entry in links.entries)
                TextButton(
                  onPressed: () => context.push(entry.value),
                  child: Text(entry.key),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

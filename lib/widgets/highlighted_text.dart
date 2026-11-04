import 'package:flutter/material.dart';

/// Szöveg, amelyben a [highlight] minden előfordulása (kis-nagybetűtől függetlenül)
/// ki van emelve – pl. a szó a példamondatban.
class HighlightedText extends StatelessWidget {
  const HighlightedText(
    this.text, {
    super.key,
    required this.highlight,
    required this.color,
    this.style,
  });

  final String text;
  final String highlight;
  final Color color;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final needle = highlight.trim().toLowerCase();
    if (needle.isEmpty) return Text(text, style: style);

    final haystack = text.toLowerCase();
    final spans = <TextSpan>[];
    var start = 0;
    while (true) {
      final index = haystack.indexOf(needle, start);
      if (index < 0) break;
      if (index > start) spans.add(TextSpan(text: text.substring(start, index)));
      spans.add(TextSpan(
        text: text.substring(index, index + needle.length),
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ));
      start = index + needle.length;
    }
    if (start < text.length) spans.add(TextSpan(text: text.substring(start)));

    return Text.rich(TextSpan(style: style, children: spans));
  }
}

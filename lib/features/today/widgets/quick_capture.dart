import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../domain/capture.dart';

/// „Catch a word, phrase or sentence…” – beírod, és az Add képernyőn folytatod
/// kitöltött mezővel, a szöveghez illő típussal.
class QuickCapture extends StatefulWidget {
  const QuickCapture({super.key});

  @override
  State<QuickCapture> createState() => _QuickCaptureState();
}

class _QuickCaptureState extends State<QuickCapture> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    final uri = text.isEmpty
        ? Uri(path: '/add')
        : Uri(path: '/add', queryParameters: {'type': guessItemType(text).name, 'text': text});
    _controller.clear();
    FocusScope.of(context).unfocus();
    context.push(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            textInputAction: TextInputAction.go,
            onSubmitted: (_) => _submit(),
            style: const TextStyle(fontSize: 15),
            decoration: const InputDecoration(hintText: 'Catch a word, phrase or sentence…'),
          ),
        ),
        _AddButton(onPressed: _submit),
      ],
    );
  }
}

/// 52×52-es lime „3D” gomb (mint a ChunkyButton, csak ikonnal).
class _AddButton extends StatefulWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  static const _depth = 4.0;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final sink = _pressed ? _depth : 0.0;
    return Semantics(
      button: true,
      label: 'Add item',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: SizedBox(
          width: 52,
          height: 52 + _depth,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            margin: EdgeInsets.only(top: sink, bottom: _depth - sink),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: AppColors.accentShadow, offset: Offset(0, _depth - sink)),
              ],
            ),
            child: const Icon(Icons.add_rounded, size: 26, color: AppColors.onAccent),
          ),
        ),
      ),
    );
  }
}

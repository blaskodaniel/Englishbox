import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/providers.dart';
import '../domain/enums.dart';

/// Kiejtés a telefon beépített felolvasójával, a beállított akcentussal és sebességgel.
class SpeechService {
  SpeechService(this._ref);

  final Ref _ref;

  /// Csak az első használatkor jön létre (tesztekben így nem kell a plugin).
  FlutterTts? _tts;

  Future<void> speak(String text) async {
    final tts = _tts ??= FlutterTts();
    final settings = await _ref.read(settingsRepositoryProvider).get();
    await tts.stop();
    await tts.setLanguage(settings.accent == Accent.american ? 'en-US' : 'en-GB');
    await tts.setSpeechRate(switch (settings.speechSpeed) {
      SpeechSpeed.slow => 0.3,
      SpeechSpeed.normal => 0.45,
      SpeechSpeed.fast => 0.6,
    });
    await tts.speak(text);
  }

  Future<void> stop() async => _tts?.stop();
}

final speechServiceProvider = Provider<SpeechService>((ref) {
  final service = SpeechService(ref);
  ref.onDispose(service.stop);
  return service;
});

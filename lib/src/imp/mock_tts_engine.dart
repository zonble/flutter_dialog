import '../interface/tts_engine.dart';

/// A mock TTS (Text to Speech) engine for testing.
class MockTtsEngine extends TtsEngine {
  @override
  Future<void> playPrompt(String prompt) async {
    print('MockTtsEngine play $prompt');
    await Future.delayed(const Duration(milliseconds: 200));
    onComplete?.call();
  }

  @override
  Future<void> setLanguage(String language) async {}

  @override
  Future<void> setPitch(double pitch) async {}

  @override
  Future<void> setSpeechRate(double rate) async {}

  @override
  Future<void> setVoice(Map<String, String> voice) async {}

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<void> stopPlaying() async {
    onCancel?.call();
  }
}

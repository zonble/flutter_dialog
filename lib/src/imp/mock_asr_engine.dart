import '../interface/asr_engine.dart';

/// A mock ASR (Automatic Speech Recognition) engine for testing.
class MockAsrEngine extends AsrEngine {
  @override
  Future<bool> init() async => true;

  @override
  bool get isInitialized => true;

  @override
  Future<bool> startRecognition() async => true;

  @override
  Future<bool> stopRecognition() async => true;

  @override
  Future<void> setLanguage(String language) async {}
}

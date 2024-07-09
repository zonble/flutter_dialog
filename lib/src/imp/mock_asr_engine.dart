import '../interface/asr_engine.dart';

/// A mock ASR (Automatic Speech Recognition) engine for testing.
class MockAsrEngine extends AsrEngine {
  @override
  Future<bool> init() async {
    return true;
  }

  @override
  bool get isInitialized => true;

  @override
  Future<bool> startRecognition() async {
    return true;
  }

  @override
  Future<bool> stopRecognition() async {
    return true;
  }

  @override
  Future<void> setLanguage(String language) async {}
}

import 'package:flutter_dialog/flutter_dialog.dart';

extension DialogEngineMock on DialogEngine {
  /// Creates an instance of a mock [DialogEngine].
  static DialogEngine mock(String geminiApiKey) => DialogEngine(
        asrEngine: MockAsrEngine(),
        ttsEngine: MockTtsEngine(),
        nluEngine: GeminiNluEngine(apiKey: geminiApiKey),
        nlgEngine: GeminiNlgEngine(apiKey: geminiApiKey),
      );
}

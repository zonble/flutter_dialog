import 'package:flutter_dialog/flutter_dialog.dart';

class MockVuiFlowDelegate implements VuiFlowDelegate {
  var mockNluResponse = '';
  var lastTtsPrompt = '';

  @override
  Future<void> onEndingConversation() async {}

  @override
  Future<String?> onGeneratingResponse(String utterance,
      {bool useDefaultPrompt = true}) async {
    return mockNluResponse;
  }

  @override
  Future<void> onPlayingPrompt(String prompt) async {
    lastTtsPrompt = prompt;
  }

  @override
  Future<void> onSettingCurrentVuiFlow(VuiFlow? vuiFlow) async {}

  @override
  Future<void> onStartingAsr() async {}
}

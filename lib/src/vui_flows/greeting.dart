import 'package:flutter_dialog/src/interface/nlu_engine.dart';

import '../vui_flow.dart';

/// A common VUI flow for handling greeting.
class GreetingVuiFlow extends VuiFlow {
  /// The greeting message.
  var message = 'Hello. How can I help you?';
  var useNlgPrompt = false;

  GreetingVuiFlow({
    this.message = 'Hello. How can I help you?',
    this.useNlgPrompt = false,
  });

  @override
  Future<void> handle(
    NluIntent intent, {
    String? utterance,
  }) async {
    final String prompt = await () async {
      if (!useNlgPrompt) {
        return message;
      }
      var utterance = 'Generate a greeting message'
          ' which shows the willing to help the user.\n';
      utterance +=
          "The greeting message is responding to the user's sentence \"$utterance\".";
      final prompt = await delegate?.onGeneratingResponse(utterance,
          useDefaultPrompt: false);
      return prompt ?? message;
    }();

    await delegate?.onPlayingPrompt(prompt);
    await delegate?.onSettingCurrentVuiFlow(null);
    await delegate?.onStartingAsr();
  }

  @override
  String get intent => 'Greeting';
}

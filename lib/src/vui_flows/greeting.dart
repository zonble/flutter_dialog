import 'package:flutter_dialog/src/interface/nlu_engine.dart';

import '../vui_flow.dart';

/// A common VUI flow for handling greeting.
class GreetingVuiFlow extends VuiFlow {
  /// The greeting message.
  var greetingMessage = 'Hello. How can I help you?';

  /// If true, let the NLG engine generate the message to the users.
  var useNlgPrompt = false;

  GreetingVuiFlow({
    this.greetingMessage = 'Hello. How can I help you?',
    this.useNlgPrompt = false,
  });

  @override
  Future<void> handle(
    NluIntent intent, {
    String? utterance,
  }) async {
    final String prompt = await () async {
      if (!useNlgPrompt) {
        return greetingMessage;
      }
      var prompt = 'Create a response for the sentence:\n\n$utterance\n\n';
      prompt += 'The response shows the willing to help.\n';
      prompt += 'The response should be less than 30 words.\n';
      prompt += 'The response should not be another question.\n';
      prompt += 'The response should not contain emoji.\n';
      return await delegate?.onGeneratingResponse(prompt,
              useDefaultPrompt: false) ??
          greetingMessage;
    }();

    await delegate?.onPlayingPrompt(prompt);
    await delegate?.onSettingCurrentVuiFlow(null);
    await delegate?.onStartingAsr();
  }

  @override
  String get intent => 'Greeting';

  @override
  Set<NluIntentShortcut> get proposedShortcuts => {
        ('Hi', NluIntent(intent: 'Greeting', slots: {})),
        ('Hello', NluIntent(intent: 'Greeting', slots: {})),
        ('Hi there', NluIntent(intent: 'Greeting', slots: {})),
        ('Hey', NluIntent(intent: 'Greeting', slots: {})),
      };
}

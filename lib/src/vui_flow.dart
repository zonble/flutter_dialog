import 'interface/nlu_engine.dart';

/// The type definition for a NLU intent.
typedef NluIntentShortcut = (String utterance, NluIntent intent);

/// The delegate for [VuiFlow].
abstract class VuiFlowDelegate {
  /// Called when a [VuiFlow] asks to play a prompt.
  Future<void> onPlayingPrompt(String prompt);

  /// Called when a [VuiFlow] asks to set the current VUI flow, which is for
  /// next round of a conversation.
  Future<void> onSettingCurrentVuiFlow(VuiFlow? vuiFlow);

  /// Called when a [VuiFlow] asks to start speech recognition.
  Future<void> onStartingAsr();

  /// Called when a [VuiFlow] asks to end the conversation.
  Future<void> onEndingConversation();

  /// Called when a [VuiFlow] asks to generate a response by using an NLG
  /// engine.
  Future<String?> onGeneratingResponse(String utterance,
      {bool useDefaultPrompt = true});
}

/// The interface for VUI flow.
abstract class VuiFlow {
  /// Handles the given [intent]. The intent is from an NLU engine.
  Future<void> handle(
    NluIntent intent, {
    String? utterance,
  });

  /// Called when the dialog engine asks to cancel the current VUI flow.
  Future<void> cancel() async {
    delegate = null;
  }

  /// The delegate for this VUI flow.
  VuiFlowDelegate? delegate;

  /// The intent that the VUI flow can handle.
  String get intent => '';

  /// The slots that the VUI flow can handle.
  Set<String> get slots => {};

  /// The proposed shortcuts by the VUI flow.
  Set<NluIntentShortcut> get proposedShortcuts => {};

  /// The additional NLU prompt that the NLU engine to extract the intent and
  /// slots.
  String? get additionalNluPrompt => null;
}

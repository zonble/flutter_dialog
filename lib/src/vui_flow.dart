import '../flutter_dialog.dart';

/// The delegate for [VuiFlow].
abstract class VuiFlowDelegate {
  Future<void> onPlayingPrompt(String prompt);

  Future<void> onSettingCurrentVuiFlow(VuiFlow? vuiFlow);

  Future<void> onStartingAsr();

  Future<void> onEndingConversation();

  Future<String?> onGeneratingResponse(String utterance,
      {bool useDefaultPrompt = true});
}

abstract class VuiFlow {
  Future<void> handle(NluIntent intent);

  Future<void> cancel() async {
    delegate = null;
  }

  VuiFlowDelegate? delegate;

  String get intent => '';

  List<String> get slots => [];

  String? get additionalNluPrompt => null;
}

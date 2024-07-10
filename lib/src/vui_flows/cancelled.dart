import '../interface/nlu_engine.dart';
import '../vui_flow.dart';

/// A common VUI flow for handling cancelled intent.
class CancelledVuiFlow extends VuiFlow {
  /// The message to be played when the user cancels.
  String message = 'OK. Cancelled.';

  /// Creates a new instance of [CancelledVuiFlow].
  CancelledVuiFlow({this.message = 'OK. Cancelled.'});

  @override
  Future<void> handle(
    NluIntent intent, {
    String? utterance,
  }) async {
    await delegate?.onPlayingPrompt(message);
    await delegate?.onEndingConversation();
  }

  @override
  String get intent => '';

  @override
  List<String> get slots => [];
}

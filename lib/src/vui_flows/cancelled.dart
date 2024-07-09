import '../interface/nlu_engine.dart';
import '../vui_flow.dart';

/// A common VUI flow for handling cancelled intent.
class CancelledVuiFlow extends VuiFlow {
  String message = 'OK. Cancelled.';

  CancelledVuiFlow({this.message = 'OK. Cancelled.'});

  @override
  Future<void> handle(NluIntent intent) async {
    await delegate?.onPlayingPrompt(message);
    await delegate?.onEndingConversation();
  }

  @override
  String get intent => '';

  @override
  List<String> get slots => [];
}

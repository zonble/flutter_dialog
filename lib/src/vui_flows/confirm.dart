import '../common_intents.dart';
import '../interface/nlu_engine.dart';
import '../vui_flow.dart';

const _maxErrorCount = 5;

/// A common VUI flow for handling confirmation.
class ConfirmVuiFlow extends VuiFlow {
  final VuiFlow positiveFlow;
  final VuiFlow negativeFlow;
  var maxErrorMessage = 'Sorry, too many errors.';
  var errorMessage = 'Sorry, I do not understand. Please say ?';
  var errorCount = 0;

  ConfirmVuiFlow({
    required this.positiveFlow,
    required this.negativeFlow,
    this.maxErrorMessage = 'Sorry, too many errors.',
    this.errorMessage = 'Sorry, I do not understand. Please say ?',
  });

  @override
  Future<void> handle(NluIntent intent) async {
    if (commonAffirmationIntents.contains(intent.intent)) {
      positiveFlow.delegate = delegate;
      positiveFlow.handle(NluIntent(intent: '', slots: {}));
    } else if (commonNegationIntents.contains(intent.intent)) {
      negativeFlow.delegate = delegate;
      negativeFlow.handle(NluIntent(intent: '', slots: {}));
    } else {
      errorCount += 1;
      if (errorCount >= _maxErrorCount) {
        await delegate?.onPlayingPrompt(maxErrorMessage);
        await delegate?.onEndingConversation();
        return;
      }
      await delegate?.onPlayingPrompt(errorMessage);
      final newFlow =
          ConfirmVuiFlow(positiveFlow: positiveFlow, negativeFlow: negativeFlow)
            ..errorCount = errorCount;
      await delegate?.onSettingCurrentVuiFlow(newFlow);
      await delegate?.onStartingAsr();
    }
  }

  @override
  String get intent => '';

  @override
  List<String> get slots => <String>[];
}

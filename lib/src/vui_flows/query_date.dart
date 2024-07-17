import 'package:intl/intl.dart';

import '../interface/nlu_engine.dart';
import '../vui_flow.dart';

/// A common VUI flow for handling date query.
class QueryDateVuiFlow extends VuiFlow {
  @override
  Future<void> handle(NluIntent intent, {String? utterance}) async {
    final message = () {
      final intentDate = intent.slots['Date'];
      if (intentDate != null) {
        return intentDate;
      }
      final now = DateTime.now();
      final today = DateFormat.yMd().format(now);
      return "Today is $today";
    }();
    await delegate?.onPlayingPrompt(message);
    await delegate?.onEndingConversation();
  }

  @override
  String get intent => 'QueryDate';

  @override
  String? get additionalNluPrompt {
    var message = 'Convert date and time to Gregorian calendar.';
    final now = DateTime.now();
    final today = DateFormat.yMd().format(now);
    message += ' today is $today (Y-M-D)';
    return message;
  }

  @override
  Set<NluIntentShortcut> get proposedShortcuts => {
        ('What day is today', NluIntent(intent: 'QueryDate', slots: {})),
      };
}

import 'package:intl/intl.dart';

import '../interface/nlu_engine.dart';
import '../vui_flow.dart';

class QueryDateVuiFlow extends VuiFlow {
  @override
  Future<void> handle(NluIntent intent, {String? utterance}) async {
/*
    final now = DateTime.now();
    final time = DateFormat.yMd().format(now);
    final message = "Today is $time";
*/
    final message = () {
      final intentDate = intent.slots['Date'];
      if (intentDate != null) {
        return intentDate;
      }
      final now = DateTime.now();
      final time = DateFormat.jms().format(now);
      return "The current time is $time";
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
}

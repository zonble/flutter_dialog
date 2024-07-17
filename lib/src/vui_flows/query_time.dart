import 'package:intl/intl.dart';

import '../interface/nlu_engine.dart';
import '../vui_flow.dart';

/// A common VUI flow for handling time query.
class QueryTimeVuiFlow extends VuiFlow {
  @override
  Future<void> handle(NluIntent intent, {String? utterance}) async {
    final now = DateTime.now();
    final time = DateFormat.jms().format(now);
    final message = "The current time is $time";
    await delegate?.onPlayingPrompt(message);
    await delegate?.onEndingConversation();
  }

  @override
  String get intent => 'QueryTime';

  @override
  Set<NluIntentShortcut> get proposedShortcuts => {
        ('What time is it', NluIntent(intent: 'QueryTime', slots: {})),
      };
}

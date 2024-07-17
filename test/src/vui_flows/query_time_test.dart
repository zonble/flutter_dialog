import 'package:flutter_dialog/flutter_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_vui_flow_delegate.dart';

void main() {
  test('Test QueryTimeVuiFlow', () async {
    final flow = QueryTimeVuiFlow();
    final intent = NluIntent(intent: 'QueryTime', slots: {});
    final delegate = MockVuiFlowDelegate();
    flow.delegate = delegate;
    await flow.handle(intent);
    expect(delegate.lastTtsPrompt.startsWith('The current time is'), isTrue);
  });
}

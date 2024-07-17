import 'package:flutter_dialog/flutter_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_vui_flow_delegate.dart';

void main() {
  test('Test QueryDateVuiFlow', () async {
    final flow = QueryDateVuiFlow();
    final intent = NluIntent(intent: 'QueryDate', slots: {});
    final delegate = MockVuiFlowDelegate();
    flow.delegate = delegate;
    await flow.handle(intent);
    expect(delegate.lastTtsPrompt.startsWith('Today is'), isTrue);
  });
}

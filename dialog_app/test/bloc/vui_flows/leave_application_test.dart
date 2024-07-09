import 'dart:async';

import 'package:dialog_app/bloc/vui_flows/leave_application.dart';
import 'package:flutter_dialog/flutter_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

class LeaveApplicationMockDelegate extends VuiFlowDelegate {
  final completer = Completer();

  @override
  Future<void> onEndingConversation() async {
    completer.complete();
  }

  @override
  Future<String?> onGeneratingResponse(String utterance,
      {bool useDefaultPrompt = true}) async {
    if (utterance.startsWith('幫我寫一份關於我要請假的短文')) {
      return '我要請假';
    } else if (utterance.startsWith('如果一個人發生了')) {
      return '祝你早日康復';
    }
    return '';
  }

  String? lastPrompt;

  @override
  Future<void> onPlayingPrompt(String prompt) async {
    lastPrompt = prompt;
  }

  VuiFlow? currentVuiFlow;

  @override
  Future<void> onSettingCurrentVuiFlow(VuiFlow? vuiFlow) async {
    currentVuiFlow = vuiFlow;
  }

  @override
  Future<void> onStartingAsr() async {}
}

void main() {
  test('Test Leave Application VUI Flow - with slots', () async {
    final delegate = LeaveApplicationMockDelegate();
    var systemCallCalled = false;
    final vuiFlow = LeaveApplicationVuiFlow(
        onMakingLeaveApplication: (reason, date, text) async {
      expect(reason, '生病');
      expect(date, '今天');
      expect(text, '我要請假');
      systemCallCalled = true;
      return true;
    })
      ..delegate = delegate;
    final intent = NluIntent(
        intent: 'LeaveApplication', slots: {'Reason': '生病', 'Date': '今天'});
    vuiFlow.handle(intent);
    await delegate.completer.future;
    expect(systemCallCalled, isTrue);
    expect(delegate.lastPrompt, isNotNull);
    expect(delegate.lastPrompt?.contains('祝你早日康復'), isTrue);
  });
}

import 'dart:async';

import 'package:dialog_app/bloc/vui_flows/leave_application.dart';
import 'package:flutter_dialog/flutter_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

const key = 'YOUR_API_KEY';

extension DialogEngineMock on DialogEngine {

}

void main() {
  test('Test Engine 1', () async {
    final engine = DialogEngine.mock(key);
    final completer = Completer();

    engine.stateStream.listen((newState) {
      print('newState $newState');
    });
    engine.registerFlows([
      LeaveApplicationVuiFlow(
          onMakingLeaveApplication: (reason, date, text) async {
        print('onMakingLeaveApplication called');
        print(reason);
        print(date);
        print(text);
        completer.complete();
        return true;
      })
    ]);
    await engine.handleInput('我生病了，我今天下午想請假');
    await completer.future.timeout(const Duration(seconds: 20));
    print('Done');
  });

  test('Test Engine 1 - 1', () async {
    final engine = DialogEngine.mock(key);
    final completer = Completer();

    engine.stateStream.listen((newState) {
      print('newState $newState');
    });
    engine.registerFlows([
      LeaveApplicationVuiFlow(
          onMakingLeaveApplication: (reason, date, text) async {
        print('onMakingLeaveApplication called');
        print(reason);
        print(date);
        print(text);
        completer.complete();
        return true;
      })
    ]);
    await engine.handleInput('我真的太累了，整個晚上都沒睡，我今天下午想請假');
    await completer.future.timeout(const Duration(seconds: 20));
    print('Done');
  });

  test('Test Engine 1 - 2', () async {
    final engine = DialogEngine.mock(key);
    final completer = Completer();

    engine.stateStream.listen((newState) {
      print('newState $newState');
    });
    engine.registerFlows([
      LeaveApplicationVuiFlow(
          onMakingLeaveApplication: (reason, date, text) async {
        print('onMakingLeaveApplication called');
        print(reason);
        print(date);
        print(text);
        completer.complete();
        return true;
      })
    ]);
    await engine.handleInput('我真的太累了，整個晚上都沒睡，我今天想請假一直到星期三');
    await completer.future.timeout(const Duration(seconds: 20));
    print('Done');
  });

  test('Test Engine 2', () async {
    final engine = DialogEngine.mock(key);
    final completer = Completer();

    engine.registerFlows([
      LeaveApplicationVuiFlow(
          onMakingLeaveApplication: (reason, date, text) async {
        print('onMakingLeaveApplication called');
        print(reason);
        print(date);
        print(text);
        completer.complete();
        return true;
      })
    ]);
    await engine.handleInput('我想出去玩，我明天想請假');
    await completer.future.timeout(const Duration(seconds: 20));
    print('Done');
  });

  test('Test Engine with Application', () async {
    final engine = DialogEngine(
      asrEngine: MockAsrEngine(),
      ttsEngine: MockTtsEngine(),
      nluEngine: GeminiNluEngine(apiKey: key),
      nlgEngine: GeminiNlgEngine(apiKey: key),
    );

    final completer = Completer();
    var systemCallCalled = true;
    engine.registerFlows([
      LeaveApplicationVuiFlow(
          onMakingLeaveApplication: (reason, date, text) async {
        print('onMakingLeaveApplication called');
        expect(date, '明天下午');
        expect(reason, '出去玩');
        completer.complete();
        return true;
      })
    ]);
    await engine.handleInput('我想請假');
    await Future.delayed(const Duration(seconds: 5));
    await engine.handleInput('明天下午我想出去玩');
    await completer.future.timeout(const Duration(seconds: 20));
    expect(systemCallCalled, isTrue);
  });

  test('Test Engine 4', () async {
    final engine = DialogEngine.mock(key);
    final completer = Completer();

    engine.stateStream.listen((newState) {
      print('Dialog state: $newState');
    });

    engine.registerFlows([
      LeaveApplicationVuiFlow(
          onMakingLeaveApplication: (reason, date, text) async {
        print('onMakingLeaveApplication called');
        print(reason);
        print(date);
        print(text);
        completer.complete();
        return true;
      })
    ]);
    await engine.handleInput('我想請假');
    await Future.delayed(const Duration(seconds: 5));
    await engine.handleInput('我生病了');
    await Future.delayed(const Duration(seconds: 5));
    await engine.handleInput('下個星期一');
    await completer.future.timeout(const Duration(seconds: 20));
    print('Done');
  });
}

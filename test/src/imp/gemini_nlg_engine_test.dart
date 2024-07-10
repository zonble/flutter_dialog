import 'package:flutter_dialog/flutter_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

const geminiApiKey = '';

void main() {
  test('Test Time', () async {
    final engine = GeminiNluEngine(apiKey: geminiApiKey);
    engine.availableIntents = {"QueryTime"};
    final result = await engine.extractIntent('What time is it');
    print('result $result');
  });

  test('Test Date 1', () async {
    final engine = GeminiNluEngine(apiKey: geminiApiKey);
    engine.availableIntents = {"QueryDate"};
    final result = await engine.extractIntent('What day is today');
    print('result $result');
  });

  test('Test Date 2', () async {
    final engine = GeminiNluEngine(apiKey: geminiApiKey);
    engine.availableIntents = {"QueryDate"};
    engine.availableSlots = {"Offset", "Date"};
    final result = await engine.extractIntent('What day is tomorrow');
    print('result $result');
  });

  test('Test Date 3', () async {
    final engine = GeminiNluEngine(apiKey: geminiApiKey);
    engine.availableIntents = {"QueryDate"};
    engine.availableSlots = {"Offset", "Date"};
    final result = await engine.extractIntent('What day is yesterday');
    print('result $result');
  });
}

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dialog/flutter_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  OpenAI.apiKey = 'YOUR_API_KEY';
  test('', () async {
    final engine = ChatgptNluEngine();
    engine.availableIntents = {"QueryTime"};
    final result = await engine.extractIntent('What time is it');
    print('result $result');
  });

  test('Test Date 3', () async {
    final engine = ChatgptNluEngine();
    engine.availableIntents = {"QueryDate"};
    engine.availableSlots = {"Offset", "Date"};
    final result = await engine.extractIntent('What day is yesterday');
    print('result $result');
  });
}

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dialog/flutter_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  OpenAI.apiKey = 'YOUR_API_KEY';
  test('Test NLG', () async {
    final engine = ChatGptNlgEngine();
    final result = await engine.generateResponse('我想要掏空公司');
    expect(result != null, isTrue);
  });
}

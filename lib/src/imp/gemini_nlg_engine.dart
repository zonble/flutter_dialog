import 'package:google_generative_ai/google_generative_ai.dart';

import '../interface/nlg_engine.dart';

/// The Gemini based NLG (Natural Language Generating) engine.
class GeminiNlgEngine extends NlgEngine {
  /// The API key.
  final String apiKey;

  /// The Gemini model name. See also [GeminiModels] and [GeminiModelNameFactory].
  final String geminiModel;

  String? _language;

  /// Creates a new instance.
  GeminiNlgEngine({
    required this.apiKey,
    this.geminiModel = 'gemini-1.5-flash-latest',
  });

  @override
  Future<bool> init() async => true;

  @override
  Future<String?> generateResponse(
    String utterance, {
    bool useDefaultPrompt = true,
  }) async {
    final model = GenerativeModel(
      model: geminiModel,
      apiKey: apiKey,
    );

    var prompt = utterance;

    if (useDefaultPrompt) {
      prompt = 'Create a response for the sentence:\n\n$utterance\n\n';
      prompt += 'The response should be less than 30 words.\n';
      prompt += 'The response should not be another question.\n';
      prompt += 'The response should not contain emoji.\n';
      prompt += 'If the sentence is lacking of context,'
          ' just say you do not understand.';
    }
    if (_language != null) {
      prompt += 'Current language is: $_language\n';
    }

    final content = [Content.text(prompt)];
    try {
      final response = await model.generateContent(content);
      return response.text;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setLanguage(String language) async => _language = language;

  @override
  bool get isInitialized => true;
}

import 'package:google_generative_ai/google_generative_ai.dart';

import '../interface/nlg_engine.dart';

/// The Gemini based NLG (Natural Language Generating) engine.
class GeminiNlgEngine extends NlgEngine {
  /// The API key.
  final String apiKey;

  /// The Gemini model name.
  final String geminiModel;

  /// Creates a new instance.
  GeminiNlgEngine({
    required this.apiKey,
    this.geminiModel = 'gemini-1.5-flash-latest',
  });

  @override
  Future<String?> generateResponse(
    String utterance, {
    bool useDefaultPrompt = true,
    bool? preventMeaningLessMessage,
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
      if (preventMeaningLessMessage == true) {
        prompt += 'If the sentence is lacking of context.'
            ' Just say you do not understand'
            ' using the same language as the incoming sentence.';
      }
    }

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text;
  }
}

import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';

import '../interface/nlu_engine.dart';

/// The errors for [GeminiNluEngine].
@immutable
class GeminiNluEngineError implements Exception {
  /// The error message.
  final String message;

  /// Creates a new instance.
  const GeminiNluEngineError(this.message);

  @override
  String toString() {
    return '${super.toString()} $message';
  }
}

/// The Gemini based NLU (Natural Language Understanding) engine.
class GeminiNluEngine extends NluEngine {
  /// The API key.
  final String apiKey;

  /// The Gemini model name.
  final String geminiModel;

  /// Creates a new instance.
  GeminiNluEngine({
    required this.apiKey,
    this.geminiModel = 'gemini-1.5-flash-latest',
  });

  @override
  Future<NluIntent> extractIntent(
    String utterance, {
    String? currentIntent,
    String? additionalRequirement,
  }) async {
    final model = GenerativeModel(
      model: geminiModel,
      apiKey: apiKey,
    );

    var prompt =
        'Extract the intent and the slots for the sentence:\n\n$utterance\n\n';
    prompt += "The output is in JSON without any formatting.";
    prompt += "Valid intents are including: ${availableIntents.join(',')}.";
    if (currentIntent != null) {
      prompt += "The current indent is $currentIntent.";
    }
    prompt += "Valid slots are including: ${availableSlots.join(',')}.";
    prompt += "Intents are in Pascal case.";
    prompt += "If the intent is not in the valid intents, return null.";
    if (additionalRequirement != null) {
      prompt += additionalRequirement;
    }

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    final string = response.text;
    if (string == null) {
      throw const GeminiNluEngineError('Failed to generate response.');
    }
    final RegExp regex = RegExp(r'\{.*\}');
    final match = regex.firstMatch(string);
    if (match == null) {
      throw GeminiNluEngineError(
          'Failed to extract response from string $string.');
    }
    final jsonString = match.group(0);
    if (jsonString == null) {
      throw GeminiNluEngineError(
          'Failed to extract response from jsonString $jsonString.');
    }
    print('jsonString $jsonString');
    final map = json.decode(jsonString);
    final intent = NluIntent.fromMap(map);
    return intent;
  }
}

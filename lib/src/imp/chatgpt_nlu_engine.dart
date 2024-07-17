import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';

import '../interface/nlu_engine.dart';

/// ChatGPT based NLU (Natural Language Understanding) engine.
///
/// This engine uses the ChatGPT model to extract the intent and slots from the
/// user's utterance.
///
/// Please note that you need to specify the API key by setting `OpenAI.apiKey`.
class ChatgptNluEngine extends NluEngine {
  /// The ChatGPT model to use.
  ///
  /// See https://platform.openai.com/docs/models
  ///
  /// See also [ChatgptModels] and [ChatgptModelsToSting.stringRepresentation].
  final String chatGptModel;

  /// Creates a new instance.
  ChatgptNluEngine({
    this.chatGptModel = "gpt-3.5-turbo-1106",
  });

  @override
  Future<bool> init() async => true;

  @override
  Future<NluIntent> extractIntent(String utterance,
      {String? currentIntent, String? additionalRequirement}) async {
    var systemPrompt = "return any message you are given as JSON.";
    if (currentIntent != null) {
      systemPrompt += "The current indent is $currentIntent.";
    }
    systemPrompt +=
        "Valid intents are including: ${availableIntents.join(',')}.";
    systemPrompt += "Valid slots are including: ${availableSlots.join(',')}.";
    systemPrompt += "Intents are in Pascal case.";
    systemPrompt += "If the intent is not in the valid intents, return null.";
    if (additionalRequirement != null) {
      systemPrompt += additionalRequirement;
    }

    final systemMessage = OpenAIChatCompletionChoiceMessageModel(content: [
      OpenAIChatCompletionChoiceMessageContentItemModel.text(systemPrompt),
    ], role: OpenAIChatMessageRole.assistant);

    var prompt =
        'Extract the intent and the slots for the sentence:\n\n$utterance\n\n';

    final userMessage = OpenAIChatCompletionChoiceMessageModel(content: [
      OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)
    ], role: OpenAIChatMessageRole.user);

    final requestMessages = [
      systemMessage,
      userMessage,
    ];

    final chatCompletion = await OpenAI.instance.chat.create(
      model: chatGptModel,
      responseFormat: {"type": "json_object"},
      seed: 6,
      messages: requestMessages,
      temperature: 0.2,
      maxTokens: 500,
    );

    final responseText =
        chatCompletion.choices.first.message.content?.first.text;
    if (responseText is! String) {
      throw Exception('Failed to extract message from chat completion.');
    }
    final map = json.decode(responseText);
    final intent = NluIntent.fromMap(map);
    return intent;
  }

  @override
  bool get isInitialized => true;
}

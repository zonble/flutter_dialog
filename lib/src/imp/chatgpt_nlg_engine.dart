import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';

import '../interface/nlg_engine.dart';

/// ChatGPT based NLG (Natural Language Generating) engine.
///
/// This engine uses the ChatGPT model to generate a response for the user's
/// utterance.
///
/// Please note that you need to specify the API key by setting `OpenAI.apiKey`.
class ChatGptNlgEngine extends NlgEngine {
  /// The ChatGPT model to use.
  ///
  /// See https://platform.openai.com/docs/models
  final String chatGptModel;

  String? _language;

  /// Creates a new instance.
  ChatGptNlgEngine({
    this.chatGptModel = "gpt-3.5-turbo-1106",
  });

  @override
  Future<bool> init() async => true;

  @override
  Future<String?> generateResponse(String utterance,
      {bool useDefaultPrompt = true}) async {
    var systemPrompt = "return any message you are given as JSON.";
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(systemPrompt),
      ],
      role: OpenAIChatMessageRole.assistant,
    );

    var prompt = utterance;

    if (useDefaultPrompt) {
      prompt = 'Create a response for the sentence:\n\n$utterance\n\n';
      prompt += 'The response should be less than 30 words.\n';
      prompt += 'The response should not be another question.\n';
      prompt += 'The response should not contain emoji.\n';
      prompt += 'If the sentence is lacking of context.'
          ' Just say you do not understand.';
    }
    if (_language != null) {
      prompt += 'Current language is: $_language\n';
    }

    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)],
      role: OpenAIChatMessageRole.user,
    );

    final requestMessages = [
      systemMessage,
      userMessage,
    ];

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: chatGptModel,
      responseFormat: {"type": "json_object"},
      seed: 6,
      messages: requestMessages,
      temperature: 0.2,
      maxTokens: 500,
    );

    final responseText =
        chatCompletion.choices.first.message.content?.first.text;
    final responseMap = json.decode(responseText ?? '{}');
    return responseMap['response'] ?? '';
  }

  @override
  Future<void> setLanguage(String language) async {
    _language = language;
  }

  @override
  bool get isInitialized => true;
}

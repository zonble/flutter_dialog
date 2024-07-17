/// See https://platform.openai.com/docs/models/gpt-4-turbo-and-gpt-4
enum ChatgptModels {
  gpt4o,
  gpt4o_20240513,
  gpt4Turbo,
  gpt4Turbo20240409,
  gpt4TurboPreview,
  gpt4_0125Preview,
  gpt4_1106Preview,
  gpt4,
  gpt4_0613,
  gpt4_0314,
  gpt3_5Turbo_0125,
  gpt3_5Turbo,
  gpt3_5Turbo_1106,
  gpt3_5TurboInstruct,
}

extension ChatgptModelsToSting on ChatgptModels {
  String get stringRepresentation {
    switch (this) {
      case ChatgptModels.gpt4o:
        return "gpt-4o";
      case ChatgptModels.gpt4o_20240513:
        return 'gpt-4o-2024-05-13	';
      case ChatgptModels.gpt4Turbo:
        return 'gpt-4-turbo';
      case ChatgptModels.gpt4Turbo20240409:
        return 'gpt-4-turbo-2024-04-09';
      case ChatgptModels.gpt4TurboPreview:
        return 'gpt-4-turbo-preview';
      case ChatgptModels.gpt4_0125Preview:
        return 'gpt-4-0125-preview';
      case ChatgptModels.gpt4_1106Preview:
        return 'gpt-4-1106-preview';
      case ChatgptModels.gpt4:
        return 'gpt-4';
      case ChatgptModels.gpt4_0613:
        return 'gpt-4-0613';
      case ChatgptModels.gpt4_0314:
        return 'gpt-4-0314';
      case ChatgptModels.gpt3_5Turbo_0125:
        return 'gpt-3.5-turbo-0125';
      case ChatgptModels.gpt3_5Turbo:
        return 'gpt-3.5-turbo';
      case ChatgptModels.gpt3_5Turbo_1106:
        return 'gpt-3.5-turbo-1106';
      case ChatgptModels.gpt3_5TurboInstruct:
        return 'gpt-3.5-turbo-instruct';
    }
  }
}

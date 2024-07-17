/// See https://ai.google.dev/gemini-api/docs/models/gemini
enum GeminiModels {
  gemini_1_5Pro,
  gemini_1_5Flash,
  gemini_1_0Flash,
}

extension GeminiModelsToString on GeminiModels {
  String get stringRepresentation {
    switch (this) {
      case GeminiModels.gemini_1_5Pro:
        return 'gemini-1.5-pro';
      case GeminiModels.gemini_1_5Flash:
        return 'gemini-1.5-flash';
      case GeminiModels.gemini_1_0Flash:
        return 'gemini-1.0-flash';
    }
  }
}

/// See https://ai.google.dev/gemini-api/docs/models/gemini
enum GeminiModelVariant {
  latest,
  latestStable,
}

/// A helper that builds the Gemini model name
class GeminiModelNameFactory {
  /// Creates a model name by passing [model] and [variant].
  static String create({
    required GeminiModels model,
    required GeminiModelVariant variant,
  }) {
    var string = model.stringRepresentation;
    string += variant == GeminiModelVariant.latest ? '-latest' : '';
    return string;
  }
}

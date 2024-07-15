/// Interface for Natural Language Generation Engine.
///
/// Any subclass must implement the [generateResponse] method.
abstract class NlgEngine {
  /// Initializes the NLU engine.
  Future<bool> init();

  /// Generates a response for the given utterance.
  Future<String?> generateResponse(
    String utterance, {
    bool useDefaultPrompt = true,
  });

  /// Sets the language.
  Future<void> setLanguage(String language);

  /// Returns true if the engine is initialized.
  bool get isInitialized;
}

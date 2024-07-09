/// Interface for Natural Language Generation Engine
abstract class NlgEngine {
  /// Generates a response for the given utterance.
  Future<String?> generateResponse(
    String utterance, {
    bool useDefaultPrompt = true,
    bool? preventMeaningLessMessage,
  });
}

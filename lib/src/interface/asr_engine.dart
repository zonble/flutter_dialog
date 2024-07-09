enum AsrEngineState {
  listening,
  notListening,
  done,
}

/// Represents an ASR Engine.
abstract class AsrEngine {
  /// Initialized the ASR engine.
  Future<bool> init();

  /// Starts recognition.
  Future<bool> startRecognition();

  /// Stops recognition.
  Future<bool> stopRecognition();

  /// Sets the language.
  Future<void> setLanguage(String language);

  /// Called when the result is update.
  Function(String, bool)? onResult;

  /// Called when the state is changed.
  Function(AsrEngineState)? onStatusChange;

  /// Called when an error occurs.
  Function(dynamic)? onError;

  /// Returns true if the engine is initialized.
  bool get isInitialized;
}

/// The state of an [AsrEngine].
enum AsrEngineState {
  listening,
  notListening,
  done,
}

/// Represents an ASR Engine.
///
/// ASR stands for Automatic Speech Recognition, and it is also known as STT,
/// Speech to Text. An ASR engine is responsible to record user's speech and
/// convert it into text.
///
/// Any subclass must implement the [init], [startRecognition],
/// [stopRecognition] and [setLanguage] methods.,
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

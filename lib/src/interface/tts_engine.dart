import 'dart:async';

/// Represents a TTS engine.
///
/// TTS stands for Text-to-Speech. The TTS engine is responsible for playing a
/// prompt, stopping playing and so on.
abstract class TtsEngine {
  /// Initializes the TTS engine.
  Future<bool> init();

  /// Asks the TTS engine to play a prompt.
  Future<void> playPrompt(String prompt);

  /// Asks the TTS engine to stop playing.
  Future<void> stopPlaying();

  /// Sets the language of the TTS engine.
  Future<void> setLanguage(String language);

  /// Sets the speech rate of the TTS engine.
  Future<void> setSpeechRate(double rate);

  /// Sets the volume of the TTS engine.
  Future<void> setVolume(double volume);

  /// Sets the pitch of the TTS engine.
  Future<void> setPitch(double pitch);

  /// Set the voice.
  Future<void> setVoice(Map<String, String> voice);

  Function()? onStart;
  Function()? onComplete;
  Function(String text, int startOffset, int endOffset, String word)?
      onProgress;
  Function(String msg)? onError;
  Function()? onCancel;
  Function()? onPause;
  Function()? onContinue;

  /// Returns true if the engine is initialized.
  bool get isInitialized;
}
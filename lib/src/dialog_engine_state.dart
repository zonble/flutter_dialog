part of 'dialog_engine.dart';

/// Represents the states for [DialogEngine].
@immutable
abstract class DialogEngineState {}

/// Represents that [DialogEngine] is idling.
class DialogEngineIdling extends DialogEngineState {}

class DialogEngineError extends DialogEngineState {
  /// The error message.
  final String errorMessage;

  /// Creates a new instance.
  DialogEngineError({required this.errorMessage});
}

/// Represents that [DialogEngine] is listening.
class DialogEngineListening extends DialogEngineState {
  /// The ASR (Automatic Speech Recognition) result.
  final String asrResult;

  /// Creates a new instance.
  DialogEngineListening({required this.asrResult});

  @override
  toString() {
    return 'DialogEngineListening(asrResult: $asrResult)';
  }
}

/// Represents that [DialogEngine] has completed listening.
class DialogEngineCompleteListening extends DialogEngineState {
  /// The ASR (Automatic Speech Recognition) result.
  final String asrResult;

  /// Creates a new instance.
  DialogEngineCompleteListening({required this.asrResult});

  @override
  toString() {
    return 'DialogEngineCompleteListening(asrResult: $asrResult)';
  }
}

/// Represents that [DialogEngine] is playing a prompt.
class DialogEnginePlayingTts extends DialogEngineState {
  /// The prompt being played.
  final String prompt;

  /// Creates a new instance.
  DialogEnginePlayingTts({required this.prompt});

  @override
  toString() {
    return 'DialogEnginePlayingTts(prompt: $prompt)';
  }
}

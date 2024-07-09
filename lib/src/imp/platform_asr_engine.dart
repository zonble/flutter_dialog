import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../interface/asr_engine.dart';

const _pauseForSeconds = 3;

class PlatformAsrEngine extends AsrEngine {
  /// The default locale ID.
  var _localeId = 'en_US';
  var _isInitialized = false;

  @override
  Future<bool> init() async {
    print('init called');
    if (_isInitialized) {
      return _isInitialized;
    }

    final speech = stt.SpeechToText();

    _isInitialized = await speech.initialize(
        onStatus: (status) {
          final map = {
            stt.SpeechToText.listeningStatus: AsrEngineState.listening,
            stt.SpeechToText.notListeningStatus: AsrEngineState.notListening,
            stt.SpeechToText.doneStatus: AsrEngineState.done,
          };
          var state = map[status] ?? AsrEngineState.notListening;
          onStatusChange?.call(state);
        },
        onError: (error) => onError?.call(error));
    if (!_isInitialized) {
      print("The user has denied the use of speech recognition.");
    }
    return _isInitialized;
  }

  @override
  Future<bool> startRecognition() async {
    print('startRecognition called');
    if (!_isInitialized) {
      return false;
    }
    final speech = stt.SpeechToText();
    speech.listen(
        pauseFor: const Duration(seconds: _pauseForSeconds),
        localeId: _localeId,
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.search,
          partialResults: true,
          onDevice: false,
          cancelOnError: true,
        ),
        onResult: (result) {
          final words = result.recognizedWords;
          final isFinal = result.finalResult;
          onResult?.call(words, isFinal);
        });
    return true;
  }

  @override
  Future<bool> stopRecognition() async {
    print('stopRecognition called');
    if (!_isInitialized) {
      return false;
    }
    final speech = stt.SpeechToText();
    // Stopping a listen session will cause a final result to be sent
    // await speech.stop();
    await speech.cancel();
    return true;
  }

  @override
  Future<void> setLanguage(String language) async {
    _localeId = language;
  }

  @override
  bool get isInitialized => _isInitialized;
}

import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

import '../interface/tts_engine.dart';

/// Please refer to https://pub.dev/packages/flutter_tts to update your Android
/// manifest and iOS configuration.
class PlatformTtsEngine extends TtsEngine {
  final flutterTTs = FlutterTts();
  Completer? _ttsCompleter;

  /// Creates a new instance.
  PlatformTtsEngine() {
    flutterTTs.setStartHandler(() {
      onStart?.call();
    });
    flutterTTs.setCompletionHandler(() {
      // print('tts onComplete $_ttsCompleter');
      onComplete?.call();
      _ttsCompleter?.complete();
      _ttsCompleter = null;
    });
    flutterTTs.setProgressHandler((text, startOffset, endOffset, word) {
      onProgress?.call(text, startOffset, endOffset, word);
    });
    flutterTTs.setErrorHandler((msg) {
      // print('tts onError $_ttsCompleter');
      onError?.call(msg);
      _ttsCompleter?.complete();
      _ttsCompleter = null;
    });
    flutterTTs.setCancelHandler(() {
      // print('tts onCancel $_ttsCompleter');
      onCancel?.call();
      _ttsCompleter?.complete();
      _ttsCompleter = null;
    });
    flutterTTs.setPauseHandler(() {
      // print('TTS setPauseHandler');
      onPause?.call();
    });
    flutterTTs.setContinueHandler(() {
      // print('TTS setContinueHandler');
      onContinue?.call();
    });
  }

  @override
  Future<bool> init() async => true;

  @override
  Future<void> playPrompt(String prompt) async {
    await flutterTTs.speak(prompt);
    var ttsCompleter = Completer();
    _ttsCompleter = ttsCompleter;
    await ttsCompleter.future;
  }

  @override
  Future<void> stopPlaying() async {
    await flutterTTs.stop();
    _ttsCompleter?.complete();
    _ttsCompleter = null;
  }

  @override
  Future<void> setLanguage(String language) async =>
      await flutterTTs.setLanguage(language);

  @override
  Future<void> setPitch(double pitch) async => await flutterTTs.setPitch(pitch);

  @override
  Future<void> setSpeechRate(double rate) async =>
      await flutterTTs.setSpeechRate(rate);

  @override
  Future<void> setVolume(double volume) async =>
      await flutterTTs.setVolume(volume);

  @override
  Future<void> setVoice(Map<String, String> voice) async =>
      flutterTTs.setVoice(voice);

  @override
  bool get isInitialized => true;
}

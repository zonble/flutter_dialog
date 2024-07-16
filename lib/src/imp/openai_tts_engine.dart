import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../interface/tts_engine.dart';

/// Models for [OpenAiTtsEngine]
enum OpenAiTtsEngineModel {
  tts1,
  tts1Hd,
}

extension OpenAiTtsEngineModelToString on OpenAiTtsEngineModel {
  /// Converts the model to a string representation.
  String get stringRepresentation {
    switch (this) {
      case OpenAiTtsEngineModel.tts1:
        return "tts-1";
      case OpenAiTtsEngineModel.tts1Hd:
        return "tts-1-hd";
    }
  }
}

/// Voices for [OpenAiTtsEngine]
enum OpenAiTtsEngineVoice {
  alloy,
  echo,
  fable,
  onyx,
  nova,
  shimmer,
}

extension OpenAiTtsEngineVoiceToString on OpenAiTtsEngineVoice {
  /// Converts the voice to a string representation.
  String get stringRepresentation {
    switch (this) {
      case OpenAiTtsEngineVoice.alloy:
        return "alloy";
      case OpenAiTtsEngineVoice.echo:
        return "echo";
      case OpenAiTtsEngineVoice.fable:
        return "fable";
      case OpenAiTtsEngineVoice.onyx:
        return "onyx";
      case OpenAiTtsEngineVoice.nova:
        return "nova";
      case OpenAiTtsEngineVoice.shimmer:
        return "shimmer";
    }
  }
}

/// An OpenAI API based TTS (Text-to-Speech) engine.
///
/// Please note that the engine does not support Flutter Web, since it downloads
/// audio to a temporary file but Flutter Web does not support storing temporary
/// files.
class OpenAiTtsEngine extends TtsEngine {
  /// "tts-1" or "tts-1-hd".
  ///
  /// See also [OpenAiTtsEngineModel] and [OpenAiTtsEngineModelToString.stringRepresentation ].
  final String model;
  final _player = AudioPlayer();

  var _rate = 1.0;
  var _voice = "nova";
  Completer<void>? _completer;

  OpenAiTtsEngine({
    this.model = "tts-1",
  }) {
    print('Set the callbacks');
    _player.onPlayerComplete.listen((event) {
      _completer?.complete();
      _completer = null;
      onComplete?.call();
    });
    _player.onPlayerStateChanged.listen((event) {
      print('event $event');
      if (event == PlayerState.stopped ||
          event == PlayerState.completed ||
          event == PlayerState.disposed) {
        _completer?.complete();
        _completer = null;
      }
    });
    _player.onLog.listen((event) {
      print('log $event');
    });
  }

  @override
  Future<bool> init() async => true;

  @override
  bool get isInitialized => true;

  @override
  Future<void> playPrompt(String prompt) async {
    _completer?.complete();
    _completer = null;

    final tmpFilename = "${const Uuid().v4()}.mp3";
    Directory tempDir = await getTemporaryDirectory();

    try {
      final speechFile = await OpenAI.instance.audio.createSpeech(
        model: model,
        input: prompt,
        voice: _voice,
        speed: _rate,
        responseFormat: OpenAIAudioSpeechResponseFormat.mp3,
        outputDirectory: tempDir,
        outputFileName: tmpFilename,
      );

      // print(speechFile.path);
      await _player.play(
        DeviceFileSource(speechFile.path),
        mode: PlayerMode.lowLatency,
      );
      final completer = Completer();
      _completer = completer;
      await completer.future;
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Future<void> setLanguage(String language) async {
    // Not supported in OpenAI.
  }

  @override
  Future<void> setPitch(double pitch) async {
    // Not supported in OpenAI.
  }

  @override
  Future<void> setSpeechRate(double rate) async => this._rate = rate;

  /// The voice to use.
  ///
  /// - tts-1: alloy, echo, fable, onyx, nova, and shimmer (configurable)
  /// - tts-1-hd: alloy, echo, fable, onyx, nova, and shimmer (configurable,
  ///   uses OpenAI samples by default)
  ///
  /// See also [OpenAiTtsEngineVoice] and
  /// [OpenAiTtsEngineVoiceToString.stringRepresentation].
  @override
  Future<void> setVoice(Map<String, String> voice) async =>
      _voice = voice.entries.first.value;

  @override
  Future<void> setVolume(double volume) async =>
      await _player.setVolume(volume);

  @override
  Future<void> stopPlaying() async {
    onCancel?.call();
    await _player.stop();
    _completer?.complete();
    _completer = null;
  }
}

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../interface/tts_engine.dart';

enum OpenAiTtsEngineModel {
  tts1,
  tts1Hd,
}

extension OpenAiTtsEngineModelToString on OpenAiTtsEngineModel {
  String get stringRepresentation {
    switch (this) {
      case OpenAiTtsEngineModel.tts1:
        return "tts-1";
      case OpenAiTtsEngineModel.tts1Hd:
        return "tts-1-hd";
    }
  }
}

enum OpenAiTtsEngineVoice {
  alloy,
  echo,
  fable,
  onyx,
  nova,
  shimmer,
}

extension OpenAiTtsEngineVoiceToString on OpenAiTtsEngineVoice {
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
  /// See also [OpenAiTtsEngineModel].
  final String model;
  final _player = AudioPlayer();
  var _rate = 1.0;
  var _voice = "nova";

  OpenAiTtsEngine({
    this.model = "tts-1",
  });

  @override
  Future<bool> init() async => true;

  @override
  bool get isInitialized => true;

  @override
  Future<void> playPrompt(String prompt) async {
    final tmpFilename = "${const Uuid().v4()}.mp3";
    Directory tempDir = await getTemporaryDirectory();

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
    _player.play(DeviceFileSource(speechFile.path));
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
  /// See also [OpenAiTtsEngineVoice].
  @override
  Future<void> setVoice(Map<String, String> voice) async =>
      this._voice = voice.entries.first.value;

  @override
  Future<void> setVolume(double volume) async =>
      await _player.setVolume(volume);

  @override
  Future<void> stopPlaying() async => await _player.stop();
}

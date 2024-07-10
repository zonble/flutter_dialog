import 'dart:async';

import 'package:meta/meta.dart';

import 'common_intents.dart';
import 'imp/gemini_nlg_engine.dart';
import 'imp/gemini_nlu_engine.dart';
import 'imp/platform_asr_engine.dart';
import 'imp/platform_tts_engine.dart';
import 'interface/asr_engine.dart';
import 'interface/nlg_engine.dart';
import 'interface/nlu_engine.dart';
import 'interface/tts_engine.dart';
import 'vui_flow.dart';

part 'dialog_engine_state.dart';

class DialogEngine implements VuiFlowDelegate {
  /// The ASR (Automatic Speech Recognition) engine.
  final AsrEngine asrEngine;

  /// The TTS (Text to Speech) engine.
  final TtsEngine ttsEngine;

  /// The NLU (Natural Language Understanding) engine.
  final NluEngine nluEngine;

  /// The NLG (Natural Language Generating) engine.
  final NlgEngine nlgEngine;

  String fallbackErrorMessage = 'Sorry, I do not understand for now.';

  final StreamController<DialogEngineState> _stateStream = StreamController();

  DialogEngineState _state = DialogEngineIdling();

  DialogEngineState get state => _state;

  Stream<DialogEngineState> get stateStream => _stateStream.stream;

  Map<String, VuiFlow> _vuiFlowMap = {};
  VuiFlow? _currentVuiFlow;

  /// Creates a new instance.
  DialogEngine({
    required this.asrEngine,
    required this.ttsEngine,
    required this.nluEngine,
    required this.nlgEngine,
  }) {
    asrEngine.onResult = (result, isFinal) async {
      if (!isFinal) {
        _emit(DialogEngineListening(asrResult: result));
      } else {
        await handleInput(result);
      }
    };
    asrEngine.onError = (error) async {
      // print(error);
      await ttsEngine.stopPlaying();
      await asrEngine.stopRecognition();
      _emit(DialogEngineError(errorMessage: error));
    };
    asrEngine.onStatusChange = (state) async {
      if (state == AsrEngineState.listening) {
        return;
      }
      final current = this.state;
      if (current is DialogEngineCompleteListening) {
        return;
      }
      if (current is DialogEngineListening) {
        if (current.asrResult != '') {
          return;
        }
      }

      if (_currentVuiFlow != null) {
        final intent = NluIntent(intent: '', slots: {});
        await _currentVuiFlow
            ?.handle(intent)
            .timeout(const Duration(seconds: 60));
        return;
      }

      if (current is DialogEngineListening) {
        _emit(DialogEngineIdling());
      }
    };

    ttsEngine.onStart = () {};
    ttsEngine.onCancel = () {};
    ttsEngine.onError = (error) {};
    ttsEngine.onComplete = () {};
  }

  /// Creates an instance of a standard [DialogEngine].
  factory DialogEngine.standard(String geminiApiKey) {
    return DialogEngine(
      asrEngine: PlatformAsrEngine(),
      ttsEngine: PlatformTtsEngine(),
      nluEngine: GeminiNluEngine(apiKey: geminiApiKey),
      nlgEngine: GeminiNlgEngine(apiKey: geminiApiKey),
    );
  }

  Future handleInput(String input) async {
    _emit(DialogEngineCompleteListening(asrResult: input));
    await ttsEngine.stopPlaying();
    await asrEngine.stopRecognition();

    try {
      // print('extractIntent ...');
      _updateIntents();
      final additionalPrompt = _collectionAdditionalNluPrompt();
      final intent = await nluEngine.extractIntent(
        input,
        currentIntent: _currentVuiFlow?.intent,
        additionalRequirement: additionalPrompt,
      );
      // print('extractIntent done');
      if (_currentVuiFlow != null) {
        // print('_currentVuiFlow $_currentVuiFlow is handling intent');
        await _currentVuiFlow
            ?.handle(intent)
            .timeout(const Duration(seconds: 60));
        return;
      }
      final flow = _vuiFlowMap[intent.intent];
      if (flow != null) {
        // print('flow $flow is handling intent');
        await flow.handle(intent).timeout(const Duration(seconds: 60));
        return;
      }
      final prompt =
          await nlgEngine.generateResponse(input) ?? fallbackErrorMessage;
      await onPlayingPrompt(prompt);
      await stop();
    } catch (e) {
      // print('NLU error: $e');
      _currentVuiFlow = null;
      await onPlayingPrompt(fallbackErrorMessage);
      await stop();
    }
  }

  void _emit(DialogEngineState state) {
    _state = state;
    _stateStream.add(state);
  }

  Future<bool> init() async => await asrEngine.init();

  Future<bool> start({
    clearCurrentVuiFlow = true,
  }) async {
    if (!asrEngine.isInitialized) {
      return false;
    }

    if (clearCurrentVuiFlow) {
      _currentVuiFlow?.cancel();
      _currentVuiFlow = null;
    }
    await ttsEngine.stopPlaying();
    await asrEngine.stopRecognition();
    await asrEngine.startRecognition();
    _emit(DialogEngineListening(asrResult: ''));
    return true;
  }

  Future<bool> stop() async {
    if (!asrEngine.isInitialized) {
      return false;
    }

    _currentVuiFlow?.cancel();
    _currentVuiFlow = null;
    await ttsEngine.stopPlaying();
    await asrEngine.stopRecognition();
    _emit(DialogEngineIdling());
    return true;
  }

  /// Resets the list of [VuiFlow].
  void resetFlows() {
    _vuiFlowMap = {};
    _updateIntents();
  }

  /// Register a list of [VuiFlow].
  void registerFlows(List<VuiFlow> flows) {
    for (final flow in flows) {
      _vuiFlowMap[flow.intent] = flow;
      flow.delegate = this;
    }
    _updateIntents();
  }

  void _updateIntents() {
    var intents = <String>{};
    intents.addAll(commonNegationIntents);
    intents.addAll(commonAffirmationIntents);
    var slots = <String>{};

    for (final key in _vuiFlowMap.keys) {
      intents.add(key);
      final flow = _vuiFlowMap[key];
      if (flow == null) {
        continue;
      }
      slots.addAll(flow.slots);
    }
    nluEngine.availableIntents = intents;
    nluEngine.availableSlots = slots;
  }

  String _collectionAdditionalNluPrompt() {
    var prompt = '';
    for (final key in _vuiFlowMap.keys) {
      final flow = _vuiFlowMap[key];
      if (flow == null) {
        continue;
      }
      var singlePrompt = flow.additionalNluPrompt;
      if (singlePrompt != null) {
        prompt += singlePrompt;
      }
    }
    return prompt;
  }

  @override
  Future<void> onEndingConversation() async {
    await stop();
  }

  @override
  Future<String?> onGeneratingResponse(
    String utterance, {
    bool useDefaultPrompt = true,
  }) async {
    return await nlgEngine.generateResponse(
      utterance,
      useDefaultPrompt: useDefaultPrompt,
    );
  }

  @override
  Future<void> onPlayingPrompt(String prompt) async {
    // print('stop TTS');
    await ttsEngine.stopPlaying();
    // print('emit TTS state');
    _emit(DialogEnginePlayingTts(prompt: prompt));
    // print('play TTS prompt');
    await ttsEngine.playPrompt(prompt);
  }

  @override
  Future<void> onSettingCurrentVuiFlow(VuiFlow? vuiFlow) async {
    vuiFlow?.delegate = this;
    _currentVuiFlow = vuiFlow;
  }

  @override
  Future<void> onStartingAsr() async {
    // print('onStartingAsr called');

    await start(clearCurrentVuiFlow: false);
  }
}

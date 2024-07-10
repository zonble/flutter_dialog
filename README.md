# flutter_dialog

2024 and onwards © Weizhong Yang a.k.a zonble

`flutter_dialog` is a Flutter package designed to simplify the integration of a
voice assistant into your Flutter app. It provides interfaces for ASR (Automatic
Speech Recognition), NLU (Natural Language Understanding), NLG (Natural Language
Generation), and TTS (Text-to-Speech) engines, along with a default
implementation for voice interaction.

By default:

- The ASR engine utilizes the `speech_to_text` package.
- he TTS engine employs the `flutter_tts` package.
- The NLU and NLG engines leverage Google’s Gemini API.

You can easily customize your dialog flow and substitute the default engines
with your own implementations.

## Usage

The following example demonstrates how to create a dialog engine with a minimal
configuration:

```dart
// Create a DialogEngine instance with the default engines
final _dialogEngine = DialogEngine(
    asrEngine: PlatformAsrEngine(),
    ttsEngine: PlatformTtsEngine(),
    nluEngine: GeminiNluEngine(apiKey: geminiApiKey),
    nlgEngine: GeminiNlgEngine(apiKey: geminiApiKey),
);

// Set the language for the engines
await _dialogEngine.ttsEngine.setLanguage('en-US');
await _dialogEngine.asrEngine.setLanguage('en-US');
await _dialogEngine.nlgEngine.setLanguage('en-US');

// Listen to the dialog engine state
_dialogEngine.stateStream.listen((state) {
    print(state);
});

// Register the dialog flows
_dialogEngine.registerFlows([
    GreetingVuiFlow(useNlgPrompt: true),
]);

// Initialize the dialog engine
await _dialogEngine.init();

// Start the dialog engine to listen to user input
await _dialogEngine.start();

```

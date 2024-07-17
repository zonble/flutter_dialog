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

Since the package is built on various implementations of the engines, what
platform that the engine support is depending on the implementation. For
example, the default ASR engine uses the `speech_to_text` package, which only
supports iOS, Android and Web platforms. If you want to support other platforms,
you need to implement your own ASR engine.

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

The dialog engine is composed by four engines: ASR, NLU, NLG, and TTS, and run
the VUI flows among these engines. ASR engine converts users' speech to text,
then it pass the converted text to NLU engine to understand the user's intent.
After that, a VUI flow handles a known intent and decides how to respond to the
users, it may use NLG engine to generate text and then use NLG engine to play
prompts.

All of these components are customizable. So, when creating a dialog engine, you
should specify the engines you want to use. For example, you can also use a
different ASR engine which implementing the `AsrEngine` interface.

Then, register desired VUI flows to the engine, so, when the engine detect an
intent that your VUI flows can handle, it will call the VUI flow to handle the
intent. You can easily create a VUI flow using the package.

Finally, you can start the dialog engine to listen to user input.

## License

The package is released under the MIT license. See [LICENSE](LICENSE).

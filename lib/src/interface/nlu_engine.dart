/// Represents the intent and slots extracted from the user's utterance.
class NluIntent {
  /// The intent extracted from the user's utterance.
  final String intent;

  /// The slots extracted from the user's utterance.
  final Map<String, dynamic> slots;

  /// Creates a new instance.
  NluIntent({
    required this.intent,
    required this.slots,
  });

  /// Creates a new instance from a map.
  factory NluIntent.fromMap(Map json) {
    return NluIntent(
      intent: json['intent'] ?? '',
      slots: json['slots'] ?? [],
    );
  }

  @override
  String toString() {
    return '${super.toString()} intent: $intent, slots: $slots';
  }
}

/// Represents the NLU engine.
///
/// NLU stands for Natural Language Understanding. An NLU engine is responsible
/// for extracting the intent and slots from the user's utterance.
///
/// Any subclass of [NluEngine] must implement the [extractIntent] method.
abstract class NluEngine {
  Set<String> availableIntents = <String>{};
  Set<String> availableSlots = <String>{};

  /// Initializes the NLU engine.
  Future<bool> init();

  /// Extracts the intent and slots from the given utterance.
  Future<NluIntent> extractIntent(
    String utterance, {
    String? currentIntent,
    String? additionalRequirement,
  });

  /// Returns true if the engine is initialized.
  bool get isInitialized;
}

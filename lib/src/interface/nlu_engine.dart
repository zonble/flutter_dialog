class NluIntent {
  final String intent;
  final Map slots;

  NluIntent({
    required this.intent,
    required this.slots,
  });

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

abstract class NluEngine {
  Set<String> availableIntents = <String>{};
  Set<String> availableSlots = <String>{};

  Future<NluIntent> extractIntent(
    String utterance, {
    String? currentIntent,
    String? additionalRequirement,
  });
}

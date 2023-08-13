abstract class DetectionResultBase {
  /// The detected language.
  final String language;

  /// Likelihood of the language being correct, from 0-1.
  final num score;

  /// Whether translation is supported for this language.
  final bool translationSupported;

  /// Whether transliteration is supported for this language.
  final bool transliterationSupported;

  const DetectionResultBase({
    required this.language,
    required this.score,
    required this.translationSupported,
    required this.transliterationSupported,
  });
}

/// The result of a detection request.
class DetectionResult extends DetectionResultBase {
  /// The original text that was used to generate the request.
  final String text;

  final List<DetectionResult>? alternatives;

  const DetectionResult({
    required this.text,
    required super.language,
    required super.score,
    required super.translationSupported,
    required super.transliterationSupported,
    this.alternatives,
  });

  factory DetectionResult.fromJson(Map<String, dynamic> json) =>
      DetectionResult(
        text: json['text'],
        language: json['language'],
        score: json['score'],
        translationSupported: json['isTranslationSupported'],
        transliterationSupported: json['isTransliterationSupported'],
        alternatives: json.containsKey('alternatives')
            ? List<DetectionResult>.from(
                json['alternatives'].map(DetectionAlternative.fromJson))
            : null,
      );

  @override
  String toString() => 'DetectionResult($text, $language, $score, '
      '$translationSupported, $transliterationSupported)';

  /// Returns a map of all possible detected languages and their scores.
  Map<String, num> get scores => {
        language: score,
        for (final a in alternatives ?? []) a.language: a.score,
      };
}

/// An alternative result of a detection request.
class DetectionAlternative extends DetectionResultBase {
  const DetectionAlternative({
    required super.language,
    required super.score,
    required super.translationSupported,
    required super.transliterationSupported,
  });

  factory DetectionAlternative.fromJson(Map<String, dynamic> json) =>
      DetectionAlternative(
        language: json['language'],
        score: json['score'],
        translationSupported: json['isTranslationSupported'],
        transliterationSupported: json['isTransliterationSupported'],
      );

  @override
  String toString() => 'DetectionAlternative($language, $score, '
      '$translationSupported, $transliterationSupported)';
}

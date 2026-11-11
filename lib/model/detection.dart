abstract class const DetectionResultBase({
  /// The detected language.
  required final String language,

  /// Likelihood of the language being correct, from 0-1.
  required final num score,

  /// Whether translation is supported for this language.
  required final bool translationSupported,

  /// Whether transliteration is supported for this language.
  required final bool transliterationSupported,
});

/// The result of a detection request.
class const DetectionResult({
  /// The original text that was used to generate the request.
  required final String text,
  required super.language,
  required super.score,
  required super.translationSupported,
  required super.transliterationSupported,
  final List<DetectionAlternative>? alternatives,
}) extends DetectionResultBase {
  factory fromJson(Map<String, dynamic> json) => .new(
    text: json['text'],
    language: json['language'],
    score: json['score'],
    translationSupported: json['isTranslationSupported'],
    transliterationSupported: json['isTransliterationSupported'],
    alternatives: switch (json['alternatives']) {
      final List<dynamic> alternatives =>
        alternatives
            .map(
              (alternative) => DetectionAlternative.fromJson(
                alternative as Map<String, dynamic>,
              ),
            )
            .toList(),
      null => null,
      final invalid => throw FormatException(
        'Invalid detection alternatives: $invalid',
      ),
    },
  );

  @override
  String toString() =>
      'DetectionResult($text, $language, $score, '
      '$translationSupported, $transliterationSupported)';

  /// Returns a map of all possible detected languages and their scores.
  Map<String, num> get scores => {
    language: score,
    for (final a in alternatives ?? []) a.language: a.score,
  };
}

/// An alternative result of a detection request.
class const DetectionAlternative({
  required super.language,
  required super.score,
  required super.translationSupported,
  required super.transliterationSupported,
}) extends DetectionResultBase {
  factory fromJson(Map<String, dynamic> json) => .new(
    language: json['language'],
    score: json['score'],
    translationSupported: json['isTranslationSupported'],
    transliterationSupported: json['isTransliterationSupported'],
  );

  @override
  String toString() =>
      'DetectionAlternative($language, $score, '
      '$translationSupported, $transliterationSupported)';
}

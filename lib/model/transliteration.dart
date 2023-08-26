/// The result of a transliteration request.
class TransliterationResult {
  /// The language code.
  final String language;

  /// Code of the script we are transliterating from, the source script.
  final String fromScript;

  /// Code of the script we are transliterating to, the target script.
  final String toScript;

  /// One `Transliteration` for each text that was requested.
  final List<Transliteration> transliterations;

  const TransliterationResult({
    required this.language,
    required this.fromScript,
    required this.toScript,
    required this.transliterations,
  });

  Map<String, String> get map =>
      {for (final t in transliterations) t.sourceText: t.text};

  @override
  String toString() =>
      'TransliterationResult($language, $fromScript -> $toScript, $map)';
}

/// A single transliteration containing source and transliterated text.
class Transliteration {
  /// The transliterated text.
  final String text;

  /// The target script code, equal to `TransliterationResult.toScript`.
  /// It's redundant, but Azure returns it.
  final String script;

  /// Text in the source script that was used to generate the transliteration.
  final String sourceText;

  const Transliteration({
    required this.text,
    required this.script,
    required this.sourceText,
  });

  factory Transliteration.fromJson(Map<String, dynamic> json) =>
      Transliteration(
        text: json['text'],
        script: json['script'],
        sourceText: json['sourceText'],
      );

  @override
  String toString() => 'Transliteration($sourceText: $text [$script])';
}

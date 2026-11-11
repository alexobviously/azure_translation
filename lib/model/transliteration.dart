/// The result of a transliteration request.
class const TransliterationResult({
  /// The language code.
  required final String language,

  /// Code of the script we are transliterating from, the source script.
  required final String fromScript,

  /// Code of the script we are transliterating to, the target script.
  required final String toScript,

  /// One `Transliteration` for each text that was requested.
  required final List<Transliteration> transliterations,
}) {
  Map<String, String> get map => {
    for (final t in transliterations) t.sourceText: t.text,
  };

  @override
  String toString() =>
      'TransliterationResult($language, $fromScript -> $toScript, $map)';
}

/// A single transliteration containing source and transliterated text.
class const Transliteration({
  /// The transliterated text.
  required final String text,

  /// The target script code, equal to `TransliterationResult.toScript`.
  /// It's redundant, but Azure returns it.
  required final String script,

  /// Text in the source script that was used to generate the transliteration.
  required final String sourceText,
}) {
  factory fromJson(Map<String, dynamic> json) => .new(
    text: json['text'],
    script: json['script'],
    sourceText: json['sourceText'],
  );

  @override
  String toString() => 'Transliteration($sourceText: $text [$script])';
}

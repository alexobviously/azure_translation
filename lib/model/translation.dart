class TranslationResult {
  final String original;
  final List<Translation> translations;
  final DetectedLanguage? detectedLanguage;

  const TranslationResult({
    required this.original,
    required this.translations,
    this.detectedLanguage,
  });

  factory TranslationResult.fromJson(Map<String, dynamic> json) =>
      TranslationResult(
        original: json['original'],
        translations: List<Translation>.from(
            json['translations'].map((x) => Translation.fromJson(x))),
        detectedLanguage: json.containsKey('detectedLanguage')
            ? DetectedLanguage.fromJson(json['detectedLanguage'])
            : null,
      );

  Map<String, String> get map => {for (final t in translations) t.to: t.text};

  String? operator [](String to) =>
      translations.where((e) => e.to == to).firstOrNull?.text;

  @override
  String toString() => 'TranslationResult($original, $translations)';
}

class Translation {
  final String text;
  final String to;
  const Translation({required this.text, required this.to});

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        text: json['text'],
        to: json['to'],
      );

  @override
  String toString() => '$to: $text';
}

class DetectedLanguage {
  final String language;
  final num score;
  const DetectedLanguage({required this.language, required this.score});

  factory DetectedLanguage.fromJson(Map<String, dynamic> json) =>
      DetectedLanguage(
        language: json['language'],
        score: json['score'],
      );
}

import 'package:azure_translation/azure_translation.dart';

/// The result of a translation request.
class TranslationResult {
  /// The original text in the base language
  /// that was used to generate the request.
  final String text;

  /// One `Translation` for each language that was requested.
  final List<Translation> translations;

  /// The detected language of the original text, for cases where it wasn't
  /// explicitly specified.
  final DetectedLanguage? detectedLanguage;

  const TranslationResult({
    required this.text,
    required this.translations,
    this.detectedLanguage,
  });

  factory TranslationResult.fromJson(Map<String, dynamic> json) =>
      TranslationResult(
        text: json['text'],
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
  String toString() => 'TranslationResult($text, $translations)';
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

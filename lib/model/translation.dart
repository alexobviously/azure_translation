import 'package:azure_translation/azure_translation.dart';

/// The result of a translation request.
class const TranslationResult({
  /// The original text in the base language
  /// that was used to generate the request.
  required final String text,

  /// One `Translation` for each language that was requested.
  required final List<Translation> translations,

  /// The detected language of the original text, for cases where it wasn't
  /// explicitly specified.
  final DetectedLanguage? detectedLanguage,
}) {
  factory fromJson(Map<String, dynamic> json) => .new(
    text: json['text'],
    translations: (json['translations'] as List<dynamic>)
        .map(
          (translation) => Translation.fromJson(
            translation as Map<String, dynamic>,
          ),
        )
        .toList(),
    detectedLanguage: switch (json['detectedLanguage']) {
      final Map<String, dynamic> detectedLanguage => DetectedLanguage.fromJson(
        detectedLanguage,
      ),
      null => null,
      final invalid => throw FormatException(
        'Invalid detected language: $invalid',
      ),
    },
  );

  Map<String, String> get map => {for (final t in translations) t.to: t.text};

  String? operator [](String to) =>
      translations.where((e) => e.to == to).firstOrNull?.text;

  @override
  String toString() => 'TranslationResult($text, $translations)';
}

/// A single translation containing source and translated text.
class const Translation({
  required final String text,
  required final String to,
}) {
  factory fromJson(Map<String, dynamic> json) =>
      .new(text: json['text'], to: json['to']);

  @override
  String toString() => '$to: $text';
}

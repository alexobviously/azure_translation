import 'dart:convert';

/// A detected language result that will be returned in cases where `translate`
/// is called without explicitly specifying the base language.
class DetectedLanguage {
  /// The code of the detected language.
  final String language;

  /// A confidence score between 0 and 1.
  final num score;
  const DetectedLanguage({required this.language, required this.score});

  factory DetectedLanguage.fromJson(Map<String, dynamic> json) =>
      DetectedLanguage(
        language: json['language'],
        score: json['score'],
      );
}

/// Possible scopes for the language list request.
enum LanguageScope {
  translation,
  transliteration,
  dictionary;
}

/// The direction that a script is written in, either ltr (left-to-right) or
/// rtl (right-to-left).
enum ScriptDirection {
  ltr,
  rtl;

  static fromString(String str) => values.firstWhere((e) => e.name == str);
}

class LanguageList {
  final List<Language>? translation;
  final List<TranslitLanguage>? transliteration;
  final List<DictionaryLanguage>? dictionary;

  const LanguageList({
    this.translation,
    this.transliteration,
    this.dictionary,
  });

  factory LanguageList.fromJson(Map<String, dynamic> json) => LanguageList(
        translation: json.containsKey('translation')
            ? (json['translation'] as Map<String, dynamic>)
                .entries
                .map((e) => Language.fromJson({
                      'code': e.key,
                      ...(e.value as Map<String, dynamic>),
                    }))
                .toList()
            : null,
        transliteration: json.containsKey('transliteration')
            ? (json['transliteration'] as Map<String, dynamic>)
                .entries
                .map((e) => TranslitLanguage.fromJson({
                      'code': e.key,
                      ...(e.value as Map<String, dynamic>),
                    }))
                .toList()
            : null,
        dictionary: json.containsKey('dictionary')
            ? (json['dictionary'] as Map<String, dynamic>)
                .entries
                .map((e) => DictionaryLanguage.fromJson({
                      'code': e.key,
                      ...(e.value as Map<String, dynamic>),
                    }))
                .toList()
            : null,
      );

  Language? translationLanguage(String code) =>
      translation?.where((e) => e.code == code).firstOrNull;

  TranslitLanguage? transliterationLanguage(String code) =>
      transliteration?.where((e) => e.code == code).firstOrNull;

  DictionaryLanguage? dictionaryLanguage(String code) =>
      dictionary?.where((e) => e.code == code).firstOrNull;

  @override
  String toString() => 'LanguageList(translation: ${translation?.length ?? 0}, '
      'transliteration: ${transliteration?.length ?? 0}, '
      'dictionary: ${dictionary?.length ?? 0})';
}

abstract class LanguageBase {
  final String code;
  final String name;
  final String nativeName;

  const LanguageBase({
    required this.code,
    required this.name,
    required this.nativeName,
  });
}

class Language extends LanguageBase {
  final ScriptDirection scriptDirection;

  const Language({
    required super.code,
    required super.name,
    required super.nativeName,
    required this.scriptDirection,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        code: json['code'],
        name: utf8.decode(json['name'].codeUnits),
        nativeName: utf8.decode(json['nativeName'].codeUnits),
        scriptDirection: ScriptDirection.fromString(json['dir']),
      );

  @override
  String toString() =>
      'Language($code, $name, $nativeName, ${scriptDirection.name})';
}

class DictionaryLanguage extends Language {
  final List<Language> translations;

  const DictionaryLanguage({
    required super.code,
    required super.name,
    required super.nativeName,
    required super.scriptDirection,
    required this.translations,
  });

  factory DictionaryLanguage.fromJson(Map<String, dynamic> json) =>
      DictionaryLanguage(
        code: json['code'],
        name: utf8.decode(json['name'].codeUnits),
        nativeName: utf8.decode(json['nativeName'].codeUnits),
        scriptDirection: ScriptDirection.fromString(json['dir']),
        translations: (json['translations'] as List<dynamic>)
            .map((e) => Language.fromJson(e))
            .toList(),
      );

  @override
  String toString() =>
      'DictionaryLanguage($code, $name, $nativeName, ${scriptDirection.name}, '
      '${translations.length} translations)';
}

class TranslitLanguage extends LanguageBase {
  final List<ScriptLanguage> scripts;

  const TranslitLanguage({
    required super.code,
    required super.name,
    required super.nativeName,
    required this.scripts,
  });

  factory TranslitLanguage.fromJson(Map<String, dynamic> json) =>
      TranslitLanguage(
        code: json['code'],
        name: utf8.decode(json['name'].codeUnits),
        nativeName: utf8.decode(json['nativeName'].codeUnits),
        scripts: (json['scripts'] as List<dynamic>)
            .map((e) => ScriptLanguage.fromJson(e))
            .toList(),
      );

  Map<String, List<String>> get map => {
        for (final s in scripts) s.code: s.toScripts.map((e) => e.code).toList()
      };

  @override
  String toString() => 'TranslitLanguage($code, $name, $nativeName, '
      'scripts: ${scripts.map((e) => e.code).toList()})';
}

class ScriptLanguage extends Language {
  final List<Language> toScripts;

  const ScriptLanguage({
    required super.code,
    required super.name,
    required super.nativeName,
    required super.scriptDirection,
    required this.toScripts,
  });

  factory ScriptLanguage.fromJson(Map<String, dynamic> json) => ScriptLanguage(
        code: json['code'],
        name: utf8.decode(json['name'].codeUnits),
        nativeName: utf8.decode(json['nativeName'].codeUnits),
        scriptDirection: ScriptDirection.fromString(json['dir']),
        toScripts: (json['toScripts'] as List<dynamic>)
            .map((e) => Language.fromJson(e))
            .toList(),
      );
}

/// A detected language result that will be returned in cases where `translate`
/// is called without explicitly specifying the base language.
class const DetectedLanguage({
  /// The code of the detected language.
  required final String language,

  /// A confidence score between 0 and 1.
  required final num score,
}) {
  factory fromJson(Map<String, dynamic> json) =>
      .new(language: json['language'], score: json['score']);
}

/// Possible scopes for the language list request.
enum LanguageScope { translation, transliteration, dictionary }

/// The direction that a script is written in, either ltr (left-to-right) or
/// rtl (right-to-left).
enum ScriptDirection {
  ltr,
  rtl;

  static ScriptDirection fromString(String value) => switch (value) {
    'ltr' => .ltr,
    'rtl' => .rtl,
    _ => throw FormatException('Invalid script direction: $value'),
  };
}

class const LanguageList({
  final List<Language>? translation,
  final List<TranslitLanguage>? transliteration,
  final List<DictionaryLanguage>? dictionary,
}) {
  factory fromJson(Map<String, dynamic> json) => .new(
    translation: _parseLanguageMap(json['translation'], Language.fromJson),
    transliteration: _parseLanguageMap(
      json['transliteration'],
      TranslitLanguage.fromJson,
    ),
    dictionary: _parseLanguageMap(
      json['dictionary'],
      DictionaryLanguage.fromJson,
    ),
  );

  Language? translationLanguage(String code) =>
      translation?.where((e) => e.code == code).firstOrNull;

  TranslitLanguage? transliterationLanguage(String code) =>
      transliteration?.where((e) => e.code == code).firstOrNull;

  DictionaryLanguage? dictionaryLanguage(String code) =>
      dictionary?.where((e) => e.code == code).firstOrNull;

  @override
  String toString() =>
      'LanguageList(translation: ${translation?.length ?? 0}, '
      'transliteration: ${transliteration?.length ?? 0}, '
      'dictionary: ${dictionary?.length ?? 0})';
}

List<T>? _parseLanguageMap<T>(
  Object? value,
  T Function(Map<String, dynamic>) fromJson,
) => switch (value) {
  final Map<String, dynamic> languages => [
    for (final MapEntry(:key, :value) in languages.entries)
      fromJson({'code': key, ...value as Map<String, dynamic>}),
  ],
  null => null,
  final invalid => throw FormatException('Invalid language map: $invalid'),
};

abstract class const LanguageBase({
  required final String code,
  required final String name,
  required final String nativeName,
});

class const Language({
  required super.code,
  required super.name,
  required super.nativeName,
  required final ScriptDirection scriptDirection,
}) extends LanguageBase {
  factory fromJson(Map<String, dynamic> json) => .new(
    code: json['code'],
    name: json['name'],
    nativeName: json['nativeName'],
    scriptDirection: .fromString(json['dir']),
  );

  @override
  String toString() =>
      'Language($code, $name, $nativeName, ${scriptDirection.name})';
}

class const DictionaryLanguage({
  required super.code,
  required super.name,
  required super.nativeName,
  required super.scriptDirection,
  required final List<Language> translations,
}) extends Language {
  factory fromJson(Map<String, dynamic> json) => .new(
    code: json['code'],
    name: json['name'],
    nativeName: json['nativeName'],
    scriptDirection: .fromString(json['dir']),
    translations: (json['translations'] as List<dynamic>)
        .map(
          (translation) => Language.fromJson(
            translation as Map<String, dynamic>,
          ),
        )
        .toList(),
  );

  @override
  String toString() =>
      'DictionaryLanguage($code, $name, $nativeName, ${scriptDirection.name}, '
      '${translations.length} translations)';
}

class const TranslitLanguage({
  required super.code,
  required super.name,
  required super.nativeName,
  required final List<ScriptLanguage> scripts,
}) extends LanguageBase {
  factory fromJson(Map<String, dynamic> json) => .new(
    code: json['code'],
    name: json['name'],
    nativeName: json['nativeName'],
    scripts: (json['scripts'] as List<dynamic>)
        .map(
          (script) => ScriptLanguage.fromJson(script as Map<String, dynamic>),
        )
        .toList(),
  );

  Map<String, List<String>> get map => {
    for (final s in scripts) s.code: s.toScripts.map((e) => e.code).toList(),
  };

  @override
  String toString() =>
      'TranslitLanguage($code, $name, $nativeName, '
      'scripts: ${scripts.map((e) => e.code).toList()})';
}

class const ScriptLanguage({
  required super.code,
  required super.name,
  required super.nativeName,
  required super.scriptDirection,
  required final List<Language> toScripts,
}) extends Language {
  factory fromJson(Map<String, dynamic> json) => .new(
    code: json['code'],
    name: json['name'],
    nativeName: json['nativeName'],
    scriptDirection: .fromString(json['dir']),
    toScripts: (json['toScripts'] as List<dynamic>)
        .map(
          (script) => Language.fromJson(script as Map<String, dynamic>),
        )
        .toList(),
  );
}

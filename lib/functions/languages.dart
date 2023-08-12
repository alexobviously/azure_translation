import 'dart:convert';

import 'package:azure_translation/azure_translation.dart';
import 'package:elegant/elegant.dart';
import 'package:http/http.dart' as http;

/// Returns a list of supported languages for translation, transliteration, and
/// dictionary lookup.
/// [scopes] can be omitted, in which case all three scopes will be returned.
/// [baseLanguage] can optionally be provided, and the names of returned
/// languages will be translated into it.
Future<Result<LanguageList, AzureTranslationError>> languages({
  String? baseLanguage,
  Iterable<LanguageScope>? scopes,
}) async {
  const endpoint = 'https://api.cognitive.microsofttranslator.com/languages';
  scopes = scopes?.toSet();
  final List<(String, String)> queryParams = [
    ('api-version', AzureTranslation.apiVersion),
    if (scopes?.isNotEmpty ?? false)
      ('scope', scopes!.map((e) => e.name).join(',')),
  ];
  final paramString = queryParams.map((e) => '${e.$1}=${e.$2}').join('&');
  final uri = Uri.parse('$endpoint?$paramString');

  final headers = {
    if (baseLanguage != null) 'Accept-Language': baseLanguage,
  };

  final res = await http.get(uri, headers: headers);

  if (res.statusCode != 200) {
    return Result.error(AzureTranslationError.fromResponse(res));
  }

  final json = jsonDecode(res.body);
  return Result.ok(LanguageList.fromJson(json));
}

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
  http.Client? client,
}) async {
  final uniqueScopes = scopes?.toSet();
  final scope = switch (uniqueScopes) {
    final scopes? when scopes.isNotEmpty =>
      scopes.map((scope) => scope.name).join(','),
    _ => null,
  };
  final uri = Uri.https('api.cognitive.microsofttranslator.com', '/languages', {
    'api-version': AzureTranslation.apiVersion,
    'scope': ?scope,
  });

  final headers = {'Accept-Language': ?baseLanguage};

  final get = client?.get ?? http.get;
  final res = await get(uri, headers: headers);

  if (res.statusCode != 200) {
    return .error(AzureTranslationError.fromResponse(res));
  }

  final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
  return .ok(LanguageList.fromJson(json));
}

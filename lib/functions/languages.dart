import 'dart:convert';

import 'package:azure_translation/azure_translation.dart';
import 'package:elegant/elegant.dart';
import 'package:http/http.dart' as http;

Future<Result<LanguageList, int>> languages({
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
    return Result.error(res.statusCode);
  }

  final json = jsonDecode(res.body);
  return Result.ok(LanguageList.fromJson(json));
}

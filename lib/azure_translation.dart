import 'dart:convert';

import 'package:azure_translation/model/translation_response.dart';
import 'package:elegant/elegant.dart';
import 'package:http/http.dart' as http;

import 'model/languages.dart';

const _endpoint = 'https://api.cognitive.microsofttranslator.com/translate';
const _apiVersion = '3.0';

Future<Result<List<TranslationResult>, int>> translate(
  List<String> text, {
  required String key,
  required String region,
  String? from,
  required List<String> to,
}) async {
  final List<(String, String)> queryParams = [
    ('api-version', _apiVersion),
    ...to.map((e) => ('to', e)),
    if (from != null) ('from', from),
  ];

  final paramString = queryParams.map((e) => '${e.$1}=${e.$2}').join('&');
  final uri = Uri.parse('$_endpoint?$paramString');

  final headers = {
    'Ocp-Apim-Subscription-Key': key,
    'Ocp-Apim-Subscription-Region': region,
    'Content-type': 'application/json',
  };

  final texts = text.map((e) => {'text': e}).toList();

  final res = await http.post(
    uri,
    headers: headers,
    body: jsonEncode(texts),
  );

  if (res.statusCode != 200) {
    return Result.error(res.statusCode);
  }

  return Result.ok(
    List<TranslationResult>.from(
      jsonDecode(res.body).map((x) => TranslationResult.fromJson(x)),
    ),
  );
}

Future<Result<LanguageList, int>> languages({
  String? baseLanguage,
  Iterable<LanguageScope>? scopes,
}) async {
  const base = 'https://api.cognitive.microsofttranslator.com/languages';
  scopes = scopes?.toSet();
  final List<(String, String)> queryParams = [
    ('api-version', _apiVersion),
    if (scopes?.isNotEmpty ?? false)
      ('scope', scopes!.map((e) => e.name).join(',')),
  ];
  final paramString = queryParams.map((e) => '${e.$1}=${e.$2}').join('&');
  final uri = Uri.parse('$base?$paramString');

  final headers = {
    if (baseLanguage != null) 'Accept-Language': baseLanguage,
  };

  final res = await http.get(uri, headers: headers);

  if (res.statusCode != 200) {
    return Result.error(res.statusCode);
  }

  final json = jsonDecode(res.body);
  return Result.ok(LanguageList.fromJson(json));
  // return Result.ok((json['translation'] as Map<String, dynamic>)
  //     .entries
  //     .map((e) => Language.fromJson({
  //           'code': e.key,
  //           ...(e.value as Map<String, dynamic>),
  //         }))
  //     .toList());
}

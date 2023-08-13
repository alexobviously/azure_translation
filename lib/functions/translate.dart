import 'dart:convert';

import 'package:azure_translation/azure_translation.dart';
import 'package:elegant/elegant.dart';
import 'package:http/http.dart' as http;

/// Translates a list of [text] to one or more [languages].
/// [key] and [region] must be provided.
/// [baseLanguage] is an optional base language code, e.g. 'en' or 'fr'. If omitted,
/// it will be detected and each result will include a [DetectedLanguage].
Future<Result<List<TranslationResult>, AzureTranslationError>> translate(
  List<String> text, {
  required String key,
  required String region,
  String? baseLanguage,
  required List<String> languages,
}) async {
  const endpoint = 'https://api.cognitive.microsofttranslator.com/translate';
  final List<(String, String)> queryParams = [
    ('api-version', AzureTranslation.apiVersion),
    ...languages.map((e) => ('to', e)),
    if (baseLanguage != null) ('from', baseLanguage),
  ];

  final paramString = queryParams.map((e) => '${e.$1}=${e.$2}').join('&');
  final uri = Uri.parse('$endpoint?$paramString');

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
    return Result.error(AzureTranslationError.fromResponse(res));
  }

  return Result.ok(
    List<TranslationResult>.from(
      (jsonDecode(res.body) as List).indexed.map(
            (e) => TranslationResult.fromJson({
              ...e.$2,
              'text': text[e.$1],
            }),
          ),
    ),
  );
}

import 'dart:convert';

import 'package:azure_translation/azure_translation.dart';
import 'package:elegant/elegant.dart';
import 'package:http/http.dart' as http;

/// Transliterates a list of [text] in [language] from [fromScript]
/// to [toScript].
/// [key] and [region] must be provided.
Future<Result<TransliterationResult, AzureTranslationError>> transliterate(
  List<String> text, {
  required String key,
  required String region,
  required String language,
  required String fromScript,
  required String toScript,
}) async {
  const endpoint =
      'https://api.cognitive.microsofttranslator.com/transliterate';

  final queryParams = {
    'api-version': AzureTranslation.apiVersion,
    'language': language,
    'fromScript': fromScript,
    'toScript': toScript,
  };

  final paramString =
      queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
  final uri = Uri.parse('$endpoint?$paramString');

  final headers = {
    'Ocp-Apim-Subscription-Key': key,
    'Ocp-Apim-Subscription-Region': region,
    'Content-Type': 'application/json',
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

  return Result.ok(TransliterationResult(
    language: language,
    fromScript: fromScript,
    toScript: toScript,
    transliterations: [
      ...(jsonDecode(res.body) as List).indexed.map(
            (e) => Transliteration.fromJson({
              ...e.$2,
              'sourceText': text[e.$1],
            }),
          ),
    ],
  ));
}

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
  http.Client? client,
}) async {
  final uri = Uri.https(
    'api.cognitive.microsofttranslator.com',
    '/transliterate',
    {
      'api-version': AzureTranslation.apiVersion,
      'language': language,
      'fromScript': fromScript,
      'toScript': toScript,
    },
  );

  final headers = {
    'Ocp-Apim-Subscription-Key': key,
    'Ocp-Apim-Subscription-Region': region,
    'Content-Type': 'application/json',
  };

  final texts = text.map((e) => {'text': e}).toList();

  final post = client?.post ?? http.post;
  final res = await post(uri, headers: headers, body: jsonEncode(texts));

  if (res.statusCode != 200) {
    return Result.error(AzureTranslationError.fromResponse(res));
  }

  final json = jsonDecode(utf8.decode(res.bodyBytes)) as List<dynamic>;
  return Result.ok(
    TransliterationResult(
      language: language,
      fromScript: fromScript,
      toScript: toScript,
      transliterations: [
        ...json.indexed.map(
          (e) => Transliteration.fromJson({...e.$2, 'sourceText': text[e.$1]}),
        ),
      ],
    ),
  );
}

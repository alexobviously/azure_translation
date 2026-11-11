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
  http.Client? client,
}) async {
  final uri = Uri.https('api.cognitive.microsofttranslator.com', '/translate', {
    'api-version': AzureTranslation.apiVersion,
    'to': languages,
    'from': ?baseLanguage,
  });

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
    List<TranslationResult>.from(
      json.indexed.map(
        (e) => TranslationResult.fromJson({...e.$2, 'text': text[e.$1]}),
      ),
    ),
  );
}

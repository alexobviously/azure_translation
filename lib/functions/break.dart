import 'dart:convert';

import 'package:azure_translation/azure_translation.dart';
import 'package:elegant/elegant.dart';
import 'package:http/http.dart' as http;

Future<Result<List<BrokenSentence>, AzureTranslationError>> breakSentence(
  List<String> text, {
  String? language,
  String? script,
  required String key,
  required String region,
  http.Client? client,
}) async {
  final uri = Uri.https(
    'api.cognitive.microsofttranslator.com',
    '/breaksentence',
    {
      'api-version': AzureTranslation.apiVersion,
      'language': ?language,
      'script': ?script,
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
    json.indexed
        .map((e) => BrokenSentence.fromJson({...e.$2, 'text': text[e.$1]}))
        .toList(),
  );
}

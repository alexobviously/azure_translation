import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:elegant/elegant.dart';
import 'package:azure_translation/azure_translation.dart';

Future<Result<List<DetectionResult>, AzureTranslationError>> detect(
  List<String> text, {
  required String key,
  required String region,
}) async {
  const endpoint = 'https://api.cognitive.microsofttranslator.com/'
      'detect?api-version=${AzureTranslation.apiVersion}';

  final headers = {
    'Ocp-Apim-Subscription-Key': key,
    'Ocp-Apim-Subscription-Region': region,
    'Content-type': 'application/json',
  };

  final texts = text.map((e) => {'text': e}).toList();

  final res = await http.post(
    Uri.parse(endpoint),
    headers: headers,
    body: jsonEncode(texts),
  );

  if (res.statusCode != 200) {
    return Result.error(AzureTranslationError.fromResponse(res));
  }

  return Result.ok(
    (jsonDecode(res.body) as List)
        .indexed
        .map((e) => DetectionResult.fromJson({
              ...e.$2,
              'text': text[e.$1],
            }))
        .toList(),
  );
}

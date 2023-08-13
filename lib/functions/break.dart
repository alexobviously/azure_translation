import 'dart:convert';
import 'package:elegant/elegant.dart';
import 'package:http/http.dart' as http;
import 'package:azure_translation/azure_translation.dart';

Future<Result<List<BrokenSentence>, AzureTranslationError>> breakSentence(
  List<String> text, {
  String? language,
  String? script,
  required String key,
  required String region,
}) async {
  const endpoint =
      'https://api.cognitive.microsofttranslator.com/breaksentence';

  final queryParams = {
    'api-version': AzureTranslation.apiVersion,
    if (language != null) 'language': language,
    if (script != null) 'script': script,
  };
  final paramString =
      queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');

  final headers = {
    'Ocp-Apim-Subscription-Key': key,
    'Ocp-Apim-Subscription-Region': region,
    'Content-Type': 'application/json',
  };

  final texts = text.map((e) => {'text': e}).toList();

  final res = await http.post(
    Uri.parse('$endpoint?$paramString'),
    headers: headers,
    body: jsonEncode(texts),
  );

  if (res.statusCode != 200) {
    return Result.error(AzureTranslationError.fromResponse(res));
  }

  return Result.ok(
    (jsonDecode(res.body) as List)
        .indexed
        .map((e) => BrokenSentence.fromJson({
              ...e.$2,
              'text': text[e.$1],
            }))
        .toList(),
  );
}

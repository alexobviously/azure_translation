// ignore_for_file: avoid_print

import 'package:azure_translation/azure_translation.dart';
import 'package:dotenv/dotenv.dart';
import 'package:elegant/elegant.dart';

(String, String) loadEnv() {
  final env = DotEnv()..load();
  final key = env['AZURE_KEY'] ?? 'YOUR_KEY';
  final region = env['AZURE_REGION'] ?? 'YOUR_REGION';
  return (key, region);
}

const _targetLangs = ['vi', 'zh', 'ru'];

void main(List<String> queries) async {
  final (key, region) = loadEnv();
  final res = await translate(
    queries,
    // baseLanguage: 'en', // will be detected if omitted
    languages: _targetLangs,
    key: key,
    region: region,
  );

  switch (res) {
    case Ok(:final value):
      for (final translation in value) {
        print('${translation.text}: ${translation.translations}');
      }
    case Err(:final error):
      print('Error: $error');
  }
}

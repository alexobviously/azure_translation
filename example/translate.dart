import 'package:dotenv/dotenv.dart';
import 'package:azure_translation/azure_translation.dart';

(String, String) loadEnv() {
  final env = DotEnv()..load();
  final key = env['AZURE_KEY'] ?? 'YOUR_KEY';
  final region = env['AZURE_REGION'] ?? 'YOUR_REGION';
  return (key, region);
}

const _targetLangs = ['vi', 'zh', 'ru'];

void main(List<String> queries) async {
  final (key, region) = loadEnv();
  final langListResult = await languages();
  print(langListResult);

  final res = await translate(
    queries,
    // baseLanguage: 'en', // will be detected if omitted
    languages: _targetLangs,
    key: key,
    region: region,
  );

  if (!res.ok) {
    print('Error: ${res.error}');
    return;
  }
  final translations = res.object!;
  for (final t in translations) {
    print('${t.text}: ${t.translations}');
  }
}

import 'package:dotenv/dotenv.dart';
import 'package:azure_translation/azure_translation.dart';

void main(List<String> queries) async {
  final env = DotEnv()..load();
  final key = env['AZURE_KEY'] ?? 'YOUR_KEY';
  final region = env['AZURE_REGION'] ?? 'YOUR_REGION';
  final langListResult = await languages();
  print(langListResult);

  final res = await translate(
    queries,
    baseLanguage: 'en',
    languages: ['vi', 'zh', 'ru'],
    key: key,
    region: region,
  );

  if (!res.ok) {
    print('Error: ${res.error}');
    return;
  }
  final translations = res.object!;
  for (final t in translations) {
    print('${t.original}: ${t.translations}');
  }
}

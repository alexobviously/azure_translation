import 'package:azure_translation/model/languages.dart';
import 'package:dotenv/dotenv.dart';

import 'package:azure_translation/azure_translation.dart';

void main(List<String> queries) async {
  final env = DotEnv()..load();
  final key = env['AZURE_ KEY'] ?? 'YOUR_KEY';
  final region = env['AZURE_REGION'] ?? 'YOUR_REGION';
  final resx = await languages(
      baseLanguage: 'vi', scopes: {LanguageScope.transliteration});
  final langs = resx.object!.translation ?? [];
  print(resx);
  // print('translation:');
  // for (final l in langs) {
  //   print('$l');
  // }
  // final dlangs = resx.object!.dictionary ?? [];
  // print('dictionary:');
  // for (final l in dlangs) {
  //   print('$l');
  // }
  // final tllangs = resx.object!.transliteration ?? [];
  // print('transliteration:');
  // for (final l in tllangs) {
  //   print('$l');
  // }
  return;
  final res = await translate(
    queries,
    from: 'en',
    to: ['vi', 'zh'],
    key: key,
    region: region,
  );
  if (!res.ok) {
    print('Error: ${res.error}');
    return;
  }
  final translations = res.object!;
  for (final (i, q) in queries.indexed) {
    print('$q: ${translations[i].map}');
  }
  final vi = translations.first['vi']!;
  print('Vietnamese: $vi');
  final words = vi.split(' ');
  final res2 = await translate(
    words,
    to: ['en'],
    from: 'vi',
    key: key,
    region: region,
  );
  if (!res2.ok) {
    print('Error: ${res.error}');
  }
  for (final (i, q) in words.indexed) {
    print('$q: ${res2.object![i]['en']}');
  }
  final chars = translations.first['zh-Hans']!.split('');
  final res3 = await translate(
    chars,
    to: ['en'],
    from: 'zh-Hans',
    key: key,
    region: region,
  );
  for (final (i, q) in chars.indexed) {
    print('$q: ${res3.object![i]['en']}');
  }
}

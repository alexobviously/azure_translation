import 'package:azure_translation/azure_translation.dart';

void main(List<String> args) async {
  bool translation = args.contains('translation') || args.contains('t');
  bool transliteration = args.contains('transliteration') || args.contains('l');
  bool dictionary = args.contains('dictionary') || args.contains('d');

  final res = await languages(
    scopes: args.isEmpty
        ? null
        : [
            if (translation) .translation,
            if (transliteration) .transliteration,
            if (dictionary) .dictionary,
          ],
  );
  if (!res.ok) {
    print('Error: ${res.error}');
    return;
  }
  final langList = res.object!;

  if (langList.translation != null) {
    print('Translation\n----------');
    for (final lang in langList.translation!) {
      print('${lang.code}: ${lang.name}');
    }
  }

  if (langList.transliteration != null) {
    print('\nTransliteration\n---------------');
    for (final lang in langList.transliteration!) {
      print('${lang.code}: ${lang.name} (${lang.map})');
    }
  }

  if (langList.dictionary != null) {
    print('\nDictionary\n----------');
    for (final lang in langList.dictionary!) {
      print('${lang.code}: ${lang.name}');
    }
  }
}

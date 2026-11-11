// ignore_for_file: avoid_print

import 'package:azure_translation/azure_translation.dart';
import 'package:elegant/elegant.dart';

void main(List<String> args) async {
  final translation = args.contains('translation') || args.contains('t');
  final transliteration =
      args.contains('transliteration') || args.contains('l');
  final dictionary = args.contains('dictionary') || args.contains('d');

  final res = await languages(
    scopes: args.isEmpty
        ? null
        : [
            if (translation) .translation,
            if (transliteration) .transliteration,
            if (dictionary) .dictionary,
          ],
  );

  switch (res) {
    case Ok(value: final languages):
      if (languages.translation != null) {
        print('Translation\n----------');
        for (final language in languages.translation!) {
          print('${language.code}: ${language.name}');
        }
      }

      if (languages.transliteration != null) {
        print('\nTransliteration\n---------------');
        for (final language in languages.transliteration!) {
          print('${language.code}: ${language.name} (${language.map})');
        }
      }

      if (languages.dictionary != null) {
        print('\nDictionary\n----------');
        for (final language in languages.dictionary!) {
          print('${language.code}: ${language.name}');
        }
      }
    case Err(:final error):
      print('Error: $error');
  }
}

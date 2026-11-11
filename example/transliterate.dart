// ignore_for_file: avoid_print

import 'package:azure_translation/azure_translation.dart';
import 'package:elegant/elegant.dart';

import 'translate.dart';

// args: language fromScript toScript text text text...

void main(List<String> args) async {
  final (key, region) = loadEnv();

  final res = await transliterate(
    [...args.skip(3)],
    key: key,
    region: region,
    language: args.first,
    fromScript: args[1],
    toScript: args[2],
  );

  switch (res) {
    case Ok(:final value):
      print(
        value.transliterations
            .map((transliteration) {
              return '${transliteration.sourceText}: ${transliteration.text}';
            })
            .join('\n'),
      );
    case Err(:final error):
      print('Error: $error');
  }
}

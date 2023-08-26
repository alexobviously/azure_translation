import 'package:azure_translation/azure_translation.dart';

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

  if (!res.ok) {
    print('Error: ${res.error}');
    return;
  }

  print(res.object!.transliterations
      .map((e) => '${e.sourceText}: ${e.text}')
      .join('\n'));
}

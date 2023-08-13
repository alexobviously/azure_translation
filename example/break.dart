import 'package:azure_translation/azure_translation.dart';

import 'translate.dart';

void main(List<String> queries) async {
  final (key, region) = loadEnv();
  final res = await breakSentence(queries, key: key, region: region);
  if (!res.ok) {
    print('Error: ${res.error}');
    return;
  }
  final brokenSentences = res.object!;
  for (final s in brokenSentences) {
    print('${s.text}: ${s.segments}');
  }
}

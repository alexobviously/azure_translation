import 'package:azure_translation/azure_translation.dart';

import 'translate.dart';

void main(List<String> queries) async {
  final (key, region) = loadEnv();
  final res = await detect(
    queries,
    key: key,
    region: region,
  );

  if (!res.ok) {
    print('Error: ${res.error}');
    return;
  }

  final detections = res.object!;
  for (final d in detections) {
    print('${d.text}: ${d.language} (${d.score})');
  }
}

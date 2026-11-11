// ignore_for_file: avoid_print

import 'package:azure_translation/azure_translation.dart';
import 'package:elegant/elegant.dart';

import 'translate.dart';

void main(List<String> queries) async {
  final (key, region) = loadEnv();
  final res = await detect(queries, key: key, region: region);

  switch (res) {
    case Ok(:final value):
      for (final detection in value) {
        print(
          '${detection.text}: ${detection.language} (${detection.score})',
        );
      }
    case Err(:final error):
      print('Error: $error');
  }
}

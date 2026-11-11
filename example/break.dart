// ignore_for_file: avoid_print

import 'package:azure_translation/azure_translation.dart';
import 'package:elegant/elegant.dart';

import 'translate.dart';

void main(List<String> queries) async {
  final (key, region) = loadEnv();
  final res = await breakSentence(queries, key: key, region: region);
  switch (res) {
    case Ok(:final value):
      for (final sentence in value) {
        print('${sentence.text}: ${sentence.segments}');
      }
    case Err(:final error):
      print('Error: $error');
  }
}

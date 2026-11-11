import 'package:azure_translation/azure_translation.dart';

/// The result of a `breakSentence` request.
class const BrokenSentence({
  /// The original text in the base language
  /// that was used to generate the request.
  required final String text,

  /// The length of each segment of the text, as reported by Azure.
  /// You probably don't need this but it's here anyway.
  required final List<int> sentLen,

  /// Segments of the word after being split.
  required final List<String> segments,

  /// The detected language of the original text, for cases where it wasn't
  /// explicitly specified.
  final DetectedLanguage? detectedLanguage,
}) {
  factory fromJson(Map<String, dynamic> json) {
    final text = json['text'] as String;
    final sentLen = (json['sentLen'] as List).cast<int>();
    final segments = <String>[];
    int start = 0;
    for (final len in sentLen) {
      segments.add(text.substring(start, start + len));
      start += len;
    }
    return .new(
      text: text,
      sentLen: sentLen,
      segments: segments,
      detectedLanguage: switch (json['detectedLanguage']) {
        final Map<String, dynamic> detectedLanguage =>
          DetectedLanguage.fromJson(detectedLanguage),
        null => null,
        final invalid => throw FormatException(
          'Invalid detected language: $invalid',
        ),
      },
    );
  }

  @override
  String toString() => 'BrokenSentence($segments)';
}

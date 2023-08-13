import 'package:azure_translation/azure_translation.dart';

/// The result of a `breakSentence` request.
class BrokenSentence {
  /// The original text in the base language
  /// that was used to generate the request.
  final String text;

  /// The length of each segment of the text, as reported by Azure.
  /// You probably don't need this but it's here anyway.
  final List<int> sentLen;

  /// Segments of the word after being split.
  final List<String> segments;

  /// The detected language of the original text, for cases where it wasn't
  /// explicitly specified.
  final DetectedLanguage? detectedLanguage;

  const BrokenSentence({
    required this.text,
    required this.sentLen,
    required this.segments,
    this.detectedLanguage,
  });

  factory BrokenSentence.fromJson(Map<String, dynamic> json) {
    final sentLen = (json['sentLen'] as List).cast<int>();
    List<String> segments = [];
    int start = 0;
    for (final len in sentLen) {
      segments.add(json['text'].substring(start, start + len));
      start += len;
    }
    return BrokenSentence(
      text: json['text'],
      sentLen: sentLen,
      segments: segments,
      detectedLanguage: json.containsKey('detectedLanguage')
          ? DetectedLanguage.fromJson(json['detectedLanguage'])
          : null,
    );
  }

  @override
  String toString() => 'BrokenSentence($segments)';
}

import 'dart:convert';

import 'package:http/http.dart' as http;

class const AzureTranslationError({
  required final int httpCode,
  final int? code,
  final String? message,
}) {
  factory fromResponse(http.Response response) {
    int? code;
    String? message;

    try {
      final body =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final error = body['error'] as Map<String, dynamic>;
      code = error['code'];
      message = error['message'];
    } catch (_) {}

    return .new(
      httpCode: response.statusCode,
      code: code,
      message: message,
    );
  }

  @override
  String toString() => 'AzureTranslationError($httpCode, $code, $message)';
}

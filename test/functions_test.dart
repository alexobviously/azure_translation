import 'dart:convert';

import 'package:azure_translation/azure_translation.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  const key = 'test-key';
  const region = 'test-region';

  group('languages', () {
    test('sends the requested scopes and parses the response', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/languages');
        expect(request.url.queryParameters['api-version'], '3.0');
        expect(request.url.queryParameters['scope'], 'translation,dictionary');
        expect(request.headers['Accept-Language'], 'fr');

        return http.Response(
          jsonEncode({
            'translation': {
              'fr': {'name': 'French', 'nativeName': 'Français', 'dir': 'ltr'},
            },
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });
      final result = await languages(
        baseLanguage: 'fr',
        scopes: const [.translation, .dictionary],
        client: client,
      );

      final languageList = result.unwrap();
      expect(languageList.translation, hasLength(1));
      expect(languageList.translationLanguage('fr')?.nativeName, 'Français');
      expect(languageList.transliteration, isNull);
      expect(languageList.dictionary, isNull);
    });
  });

  group('translate', () {
    test('sends text and maps translations back to their source', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/translate');
        expect(request.url.queryParameters['api-version'], '3.0');
        expect(request.url.queryParameters['from'], 'en&category=formal');
        expect(request.url.queryParametersAll['to'], [
          'fr&profanityAction=Marked',
          'vi',
        ]);
        expect(request.headers['Ocp-Apim-Subscription-Key'], key);
        expect(request.headers['Ocp-Apim-Subscription-Region'], region);
        expect(jsonDecode(request.body), [
          {'text': 'hello'},
          {'text': 'good morning'},
        ]);

        return http.Response(
          jsonEncode([
            {
              'translations': [
                {'text': 'bonjour', 'to': 'fr'},
                {'text': 'xin chào', 'to': 'vi'},
              ],
            },
            {
              'translations': [
                {'text': 'bonjour', 'to': 'fr'},
                {'text': 'chào buổi sáng', 'to': 'vi'},
              ],
            },
          ]),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });
      final result = await translate(
        const ['hello', 'good morning'],
        key: key,
        region: region,
        baseLanguage: 'en&category=formal',
        languages: const ['fr&profanityAction=Marked', 'vi'],
        client: client,
      );

      final translations = result.unwrap();
      expect(translations, hasLength(2));
      expect(translations.first.text, 'hello');
      expect(translations.first['fr'], 'bonjour');
      expect(translations.last.text, 'good morning');
      expect(translations.last['vi'], 'chào buổi sáng');
    });
  });

  group('detect', () {
    test('parses primary and alternative detections', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/detect');
        expect(jsonDecode(request.body), [
          {'text': 'bonjour'},
        ]);

        return http.Response(
          jsonEncode([
            {
              'language': 'fr',
              'score': 0.95,
              'isTranslationSupported': true,
              'isTransliterationSupported': false,
              'alternatives': [
                {
                  'language': 'en',
                  'score': 0.05,
                  'isTranslationSupported': true,
                  'isTransliterationSupported': false,
                },
              ],
            },
          ]),
          200,
        );
      });
      final result = await detect(
        const ['bonjour'],
        key: key,
        region: region,
        client: client,
      );

      final detection = result.unwrap().single;
      expect(detection.text, 'bonjour');
      expect(detection.language, 'fr');
      expect(detection.scores, {'fr': 0.95, 'en': 0.05});
    });
  });

  group('transliterate', () {
    test('parses transliterations with their source text', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/transliterate');
        expect(request.url.queryParameters['language'], 'ja');
        expect(request.url.queryParameters['fromScript'], 'Latn');
        expect(request.url.queryParameters['toScript'], 'Jpan');

        return http.Response(
          jsonEncode([
            {'text': 'こんにちわ', 'script': 'Jpan'},
          ]),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });
      final result = await transliterate(
        const ['konnichiwa'],
        key: key,
        region: region,
        language: 'ja',
        fromScript: 'Latn',
        toScript: 'Jpan',
        client: client,
      );

      final transliteration = result.unwrap();
      expect(transliteration.language, 'ja');
      expect(transliteration.map, {'konnichiwa': 'こんにちわ'});
    });
  });

  group('breakSentence', () {
    test('splits text using the lengths returned by Azure', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/breaksentence');

        return http.Response(
          jsonEncode([
            {
              'sentLen': [7, 6],
              'detectedLanguage': {'language': 'en', 'score': 1},
            },
          ]),
          200,
        );
      });
      final result = await breakSentence(
        const ['Hello. World.'],
        key: key,
        region: region,
        client: client,
      );

      final brokenSentence = result.unwrap().single;
      expect(brokenSentence.segments, ['Hello. ', 'World.']);
      expect(brokenSentence.detectedLanguage?.language, 'en');
    });
  });

  test('returns Azure error details for unsuccessful responses', () async {
    final client = MockClient(
      (_) async => http.Response(
        jsonEncode({
          'error': {'code': 400001, 'message': 'Invalid request.'},
        }),
        400,
      ),
    );
    final result = await languages(client: client);

    final error = result.unwrapError();
    expect(error.httpCode, 400);
    expect(error.code, 400001);
    expect(error.message, 'Invalid request.');
  });
}

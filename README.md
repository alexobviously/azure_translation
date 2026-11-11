# A wrapper for interacting with Azure's translation API.

Currently supports:
* Listing languages
* Translation
* Transliteration
* Language detection
* Breaking sentences

## Listing Languages
[Azure Reference](https://learn.microsoft.com/en-us/azure/ai-services/translator/reference/v3-0-languages)  

Listing languages is simple:
```dart
import 'package:azure_translation/azure_translation.dart' as at;
// ...
final langs = (await at.languages()).unwrap();
print(langs.translation?.take(4).join('\n'));
// Language(af, Afrikaans, Afrikaans, ltr)
// Language(am, Amharic, አማርኛ, ltr)
// Language(ar, Arabic, العربية, rtl)
// Language(as, Assamese, অসমীয়া, ltr)
```

The language list contains lists of `translation`, `transliteration` and `dictionary` languages.
It is possible to only request one or two of these scopes by passing the optional `scopes` parameter:
```dart
at.languages(scopes: const [.translation]);
```

There is also an optional `baseLanguage` parameter, which sets the `Accept-Language` header.

```dart
final langs = (await at.languages(baseLanguage: 'fr')).unwrap();
print(langs.translationLanguage('en'));
// Language(en, Anglais, English, ltr)
```

## Translation
[Azure Reference](https://learn.microsoft.com/en-us/azure/ai-services/translator/reference/v3-0-translate)  

```dart
import 'package:azure_translation/azure_translation.dart' as at;

final res = await at.translate(
    ['hello world', 'good morning'],
    baseLanguage: 'en', // optional
    languages: ['fr', 'vi', 'ar'],
    key: 'YOUR_AZURE_KEY',
    region: 'YOUR_AZURE_REGION',
);
print(res.unwrap().join('\n'));
// TranslationResult(hello world, [fr: Salut tout le monde, vi: Chào thế giới, ar: مرحبا بالعالم])
// TranslationResult(good morning, [fr: Bonjour, vi: Xin chào, ar: صباح الخير])
```

## Transliteration
[Azure Reference](https://learn.microsoft.com/en-us/azure/ai-services/translator/reference/v3-0-transliterate)

```dart
final res = await transliterate(
    ['konnichiwa', 'arigato', 'sayounara'],
    key: key,
    region: region,
    language: 'ja',
    fromScript: 'Latn',
    toScript: 'Jpan',
  );
print(res.unwrap());
// TransliterationResult(ja, Latn -> Jpan, {konnichiwa: こんにちわ, arigato: ありがと, sayounara: さようなら})
```

## Language Detection
[Azure Reference](https://learn.microsoft.com/en-us/azure/ai-services/translator/reference/v3-0-detect)  

```dart
final res = await detect(
    ['bonjour', 'hola', 'здравейте'],
    key: key,
    region: region,
);
final detections = res.unwrap();
print(detections.join('\n'));
// DetectionResult(bonjour, fr, 1.0, true, false)
// DetectionResult(hola, es, 1.0, true, false)
// DetectionResult(здравейте, bg, 1.0, true, true)
print(detections.first.scores);
// {fr: 1.0}
```

## Breaking Sentences
[Azure Reference](https://learn.microsoft.com/en-us/azure/ai-services/translator/reference/v3-0-break-sentence)  

```dart
final res = await breakSentence(
    [
        'How are you? I am fine. What did you do today?',
        '¿hola, cómo estás? ¿Donde está la biblioteca?',
    ],
    key: key,
    region: region,
);
print(res.unwrap().join('\n'));
// BrokenSentence([How are you? , I am fine. , What did you do today?])
// BrokenSentence([¿hola, cómo estás? , ¿Donde está la biblioteca?])
```


## Error handling
Non-successful Azure responses are returned using the result pattern from the
`elegant` package. Transport failures, malformed responses, and calling
`unwrap()` on an error result can still throw.

Like so:
```dart
final result = await languages();
result.fold(
  onOk: (languages) => print('Success! Language list: $languages'),
  onError: (error) => print('Error! $error'),
);
```
# A wrapper for interacting with Azure's translation API.

Currently supports:
* Listing languages
* Translation
* Language detection
* Breaking sentences

Coming soon:
* Transliteration

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
listLanguages(scopes: [LanguageScope.translation]);
```

There is also an optional `baseLanguage` parameter, which sets the `Accept-Language` header.

```dart
final langs = (await at.languages(baseLanguage: 'fr')).unwrap();
print(langs.translationLanguage('en'));
// Language(en, Anglais, English, ltr)
```

## Translation
[Azure Reference](https://learn.microsoft.com/en-us/azure/ai-services/translator/reference/v3-0-translate)  

Docs coming soon but this is self explanatory for now:
```dart
import 'package:azure_translation/azure_translation.dart' as at;

final res = await at.translate(
    ['hello world', 'good morning'],
    baseLanguage: 'en', // optional
    languages: ['fr', 'vi', 'ar'],
    key: 'YOUR_AZURE_KEY',
    region: 'YOUR_AZURE_REGION',
);
print(res.object!.join('\n'));
// TranslationResult(hello world, [fr: Salut tout le monde, vi: Chào thế giới, ar: مرحبا بالعالم])
// TranslationResult(good morning, [fr: Bonjour, vi: Xin chào, ar: صباح الخير])
```

## Language Detection
[Azure Reference](https://learn.microsoft.com/en-us/azure/ai-services/translator/reference/v3-0-detect)  

Docs coming soon but this is self explanatory for now:
```dart
final res = await detect(
    ['bonjour', 'hola', 'здравейте'],
    key: key,
    region: region,
);
print(res.object!.join('\n'));
// DetectionResult(bonjour, fr, 1.0, true, false)
// DetectionResult(hola, es, 1.0, true, false)
// DetectionResult(здравейте, bg, 1.0, true, true)
print(res.object!.first.scores);
// {fr: 1.0}
```

## Breaking Sentences
[Azure Reference](https://learn.microsoft.com/en-us/azure/ai-services/translator/reference/v3-0-break-sentence)  

Docs coming soon but this is self explanatory for now:
```dart
final res = await breakSentence(
    [
        'How are you? I am fine. What did you do today?',
        '¿hola, cómo estás? ¿Donde está la biblioteca?',
    ],
    key: key,
    region: region,
);
print(res.object!.join('\n'));
// BrokenSentence([How are you? , I am fine. , What did you do today?])
// BrokenSentence([¿hola, cómo estás? , ¿Donde está la biblioteca?])
``````


## Error handling
Error handling in this package is all done using the result class pattern. There are no exceptions unless something goes wrong with HTTP (e.g. you have no connection). Specifically, it uses the result class from the elegant package.

Like so:
```dart
final langs = await languages();
final Result<LanguageList, AzureTranslationError> res = await languages();
if (res.ok) {
    final LanguageList languageList = res.object!;
    print('Success! Language list: $languageList');
} else {
    final AzureTranslationError error = res.error!;
    print('Error! $error');
}
```
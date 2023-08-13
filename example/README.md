To run these examples, you need to create a `.env` file in whatever directory you execute from.
The `.env` should have the following variables:
```
AZURE_KEY=YOUR_AZURE_KEY
AZURE_REGION=YOUR_AZURE_REGION
```

## Translate

`dart example/translate.dart 'hello world' banana bonjour`
=>
```
hello world: [vi: Chào thế giới, zh-Hans: 世界您好, ru: Всем привет]
banana: [vi: chuối, zh-Hans: 香蕉, ru: банан]
bonjour: [vi: Xin chào, zh-Hans: 你好, ru: Привет]
```

You can change the target languages in the script.

## Detect

`dart example/detect.dart unambiguous wiedervereinigung zmaj 'chuột túi'`
=>
```
unambiguous: en (1.0)
wiedervereinigung: de (1.0)
zmaj: hr (1.0)
chuột túi: vi (1.0)
```
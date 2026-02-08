![Remote Flutter Translate](resources/images/remote_flutter_translate.png)

---

Remote Flutter Translate is a localization / internationalization (i18n) library for Flutter.

It lets you define translations for your content in different languages and switch between them easily.

## Example

![Example](resources/gifs/remote_flutter_translate_screen.gif)

## Features

* Very easy to use
* `Mobile`, `Web`, and `Desktop` support
* `Pluralization` and `Duals` support
* Supports both `languageCode (en)` and `languageCode_countryCode (en_US)` locale formats
* Automatically save and restore the selected locale
* Full support for right-to-left locales
* Fallback locale support if the system locale is unsupported
* Supports both inline and nested JSON
* No dependency on `intl` or `universal_io`
* Loads translations from assets by default, with optional overrides

## Overrides

By default, translations are loaded from assets (`assets/i18n`). You can override them at runtime with a remote JSON or a local file.

Remote JSON:
```dart
final delegate = await LocalizationDelegate.create(
  fallbackLocale: 'en_US',
  supportedLocales: ['en_US', 'da', 'de'],
  translationOverrides: TranslationOverrides.fromUrlTemplate(
    'https://example.com/i18n/{locale}.json',
  ),
);
```
This will load `.../en_US.json`, `.../da.json`, and `.../de.json` as you switch locales.

Local file (downloaded to device storage):
```dart
final delegate = await LocalizationDelegate.create(
  fallbackLocale: 'en_US',
  supportedLocales: ['en_US', 'es'],
  translationOverrides: TranslationOverrides.fromFileTemplate(
    '/path/to/i18n/{locale}.json',
  ),
);
```

Fallback behavior:
* If the override fails or returns empty for a locale, the asset translation is used.
* If a locale is unsupported, the `fallbackLocale` is used.
* Missing keys fall back to the key string itself.

## Documentation

See the example project in `example` for a full working setup.

## Issues

Please file issues and feature requests in this repository.

## License

This project is licensed under the MIT License. See `LICENSE`.
Third-party licenses are listed under `LICENSES`.

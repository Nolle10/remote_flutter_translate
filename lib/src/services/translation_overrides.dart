import 'package:flutter/widgets.dart';
import 'translation_override_platform.dart';

typedef TranslationOverrideLoader = Future<String?> Function(Locale locale);

class TranslationOverrides
{
    final TranslationOverrideLoader _loader;

    const TranslationOverrides(this._loader);

    Future<String?> load(Locale locale) => _loader(locale);

    factory TranslationOverrides.fromUrlTemplate(
        String urlTemplate, {
        Map<String, String>? headers,
        bool languageCodeOnly = false,
    })
    {
        return TranslationOverrides((locale) {
            final url = _resolveTemplate(urlTemplate, locale, languageCodeOnly);
            return fetchRemoteString(url, headers: headers);
        });
    }

    factory TranslationOverrides.fromFileTemplate(
        String pathTemplate, {
        bool languageCodeOnly = false,
    })
    {
        return TranslationOverrides((locale) {
            final path = _resolveTemplate(pathTemplate, locale, languageCodeOnly);
            return readLocalFile(path);
        });
    }
}

String _resolveTemplate(String template, Locale locale, bool languageCodeOnly)
{
    final localeString = languageCodeOnly ? locale.languageCode : _localeToString(locale);

    return template.replaceAll('{locale}', localeString);
}

String _localeToString(Locale locale)
{
    final countryCode = locale.countryCode;

    if (countryCode != null && countryCode.isNotEmpty)
    {
        return '${locale.languageCode}_$countryCode';
    }

    return locale.languageCode;
}

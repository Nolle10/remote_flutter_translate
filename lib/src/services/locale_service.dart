import 'dart:convert';
import 'dart:ui';
import 'package:remote_flutter_translate/remote_flutter_translate.dart';

import 'locale_file_service.dart';

class LocaleService {
  static Future<Map<Locale, String>> getLocalesMap(
      List<String> locales, String basePath) async {
    var files = await LocaleFileService.getLocaleFiles(locales, basePath);

    return files.map((x, y) => MapEntry(localeFromString(x), y));
  }

  static Locale? findLocale(Locale locale, List<Locale> supportedLocales) {
    // Not supported by all null safety versions
    Locale?
        existing; // = supportedLocales.firstWhereOrNull((x) => x == locale);

    for (var x in supportedLocales) {
      if (x == locale) {
        existing = x;
        break;
      }
    }

    if (existing == null) {
      // Not supported by all null safety versions
      // existing = supportedLocales.firstWhereOrNull((x) => x.languageCode == locale.languageCode);
      for (var x in supportedLocales) {
        if (x.languageCode == locale.languageCode) {
          existing = x;
          break;
        }
      }
    }

    return existing;
  }

  static Future<Map<String, dynamic>> getLocaleContent(
    Locale locale,
    Map<Locale, String> supportedLocales, {
    TranslationOverrides? overrides,
  }) async {
    String? content;

    if (overrides != null) {
      try {
        content = await overrides.load(locale);
      } catch (_) {
        content = null;
      }
    }

    if (content == null) {
      var file = supportedLocales[locale];

      if (file == null) return {};

      content = await LocaleFileService.getLocaleContent(file);
    }

    if (content == null) return {};

    return json.decode(content);
  }
}

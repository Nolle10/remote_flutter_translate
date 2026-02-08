// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
// This is a lightweight shim that preserves Intl.plural behavior without
// depending on the intl package.

import 'plural_rules.dart' as plural_rules;

class IntlShim {
  static const String _systemLocale = 'en_US';
  static String? _defaultLocale;

  static String? get defaultLocale => _defaultLocale;

  static set defaultLocale(String? newLocale) {
    _defaultLocale = newLocale;
  }

  static String _currentLocale() {
    return _defaultLocale ?? _systemLocale;
  }

  static String plural(
    num howMany, {
    String? zero,
    String? one,
    String? two,
    String? few,
    String? many,
    required String other,
    String? locale,
    int? precision,
    bool useExplicitNumberCases = true,
  }) {
    return pluralLogic(
      howMany,
      zero: zero,
      one: one,
      two: two,
      few: few,
      many: many,
      other: other,
      locale: locale,
      precision: precision,
      useExplicitNumberCases: useExplicitNumberCases,
    );
  }

  static T pluralLogic<T>(
    num howMany, {
    T? zero,
    T? one,
    T? two,
    T? few,
    T? many,
    required T other,
    String? locale,
    int? precision,
    bool useExplicitNumberCases = true,
  }) {
    ArgumentError.checkNotNull(other, 'other');
    ArgumentError.checkNotNull(howMany, 'howMany');

    var truncated = howMany.truncate();
    if (precision == null && truncated == howMany) {
      howMany = truncated;
    }

    if (useExplicitNumberCases && (precision == null || precision == 0)) {
      if (howMany == 0 && zero != null) return zero;
      if (howMany == 1 && one != null) return one;
      if (howMany == 2 && two != null) return two;
    }

    var pluralRule = _pluralRule(locale, howMany, precision);
    var pluralCase = pluralRule();
    switch (pluralCase) {
      case plural_rules.PluralCase.ZERO:
        return zero ?? other;
      case plural_rules.PluralCase.ONE:
        return one ?? other;
      case plural_rules.PluralCase.TWO:
        return two ?? few ?? other;
      case plural_rules.PluralCase.FEW:
        return few ?? other;
      case plural_rules.PluralCase.MANY:
        return many ?? other;
      case plural_rules.PluralCase.OTHER:
        return other;
      default:
        throw ArgumentError.value(howMany, 'howMany', 'Invalid plural argument');
    }
  }

  static plural_rules.PluralRule? _cachedPluralRule;
  static String? _cachedPluralLocale;

  static plural_rules.PluralRule _pluralRule(
    String? locale,
    num howMany,
    int? precision,
  ) {
    plural_rules.startRuleEvaluation(howMany, precision);
    var verifiedLocale = _verifiedLocale(
      locale,
      plural_rules.localeHasPluralRules,
      onFailure: (_) => 'default',
    );
    if (_cachedPluralLocale == verifiedLocale) {
      return _cachedPluralRule!;
    } else {
      _cachedPluralRule = plural_rules.pluralRules[verifiedLocale];
      _cachedPluralLocale = verifiedLocale;
      return _cachedPluralRule!;
    }
  }

  static String? _verifiedLocale(
    String? newLocale,
    bool Function(String) localeExists, {
    String? Function(String)? onFailure,
  }) {
    if (newLocale == null) {
      return _verifiedLocale(_currentLocale(), localeExists, onFailure: onFailure);
    }

    if (localeExists(newLocale)) {
      return newLocale;
    }

    final fallbackOptions = [
      _canonicalizedLocale,
      _shortLocale,
      _deprecatedLocale,
      (locale) => _deprecatedLocale(_shortLocale(locale)),
      (locale) => _deprecatedLocale(_canonicalizedLocale(locale)),
      (_) => 'fallback',
    ];

    for (var option in fallbackOptions) {
      var localeFallback = option(newLocale);
      if (localeExists(localeFallback)) {
        return localeFallback;
      }
    }

    return (onFailure ?? _throwLocaleError)(newLocale);
  }

  static String _canonicalizedLocale(String? aLocale) {
    if (aLocale == null) return _currentLocale();
    if (aLocale == 'C') return 'en_ISO';
    if (aLocale.length < 5) return aLocale;

    var separatorIndex = _separatorIndex(aLocale);
    if (separatorIndex == -1) {
      return aLocale;
    }
    var language = aLocale.substring(0, separatorIndex);
    var region = aLocale.substring(separatorIndex + 1);
    if (region.length <= 3) region = region.toUpperCase();
    return '${language}_$region';
  }

  static int _separatorIndex(String locale) {
    if (locale.length < 3) {
      return -1;
    }
    if (locale[2] == '-' || locale[2] == '_') {
      return 2;
    }
    if (locale.length < 4) {
      return -1;
    }
    if (locale[3] == '-' || locale[3] == '_') {
      return 3;
    }
    return -1;
  }

  static String _shortLocale(String aLocale) {
    if (aLocale == 'invalid') {
      return 'in';
    }
    if (aLocale.length < 2) {
      return aLocale;
    }
    var separatorIndex = _separatorIndex(aLocale);
    if (separatorIndex == -1) {
      if (aLocale.length < 4) {
        return aLocale.toLowerCase();
      } else {
        return aLocale;
      }
    }
    return aLocale.substring(0, separatorIndex).toLowerCase();
  }

  static String _deprecatedLocale(String aLocale) {
    switch (aLocale) {
      case 'iw':
        return 'he';
      case 'he':
        return 'iw';
      case 'fil':
        return 'tl';
      case 'tl':
        return 'fil';
      case 'id':
        return 'in';
      case 'in':
        return 'id';
      case 'no':
        return 'nb';
      case 'nb':
        return 'no';
    }
    return aLocale;
  }

  static String _throwLocaleError(String localeName) {
    throw ArgumentError('Invalid locale "$localeName"');
  }
}

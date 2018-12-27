import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class I18n {
  I18n(this.locale);

  final Locale locale;

  static I18n of(BuildContext context) => Localizations.of<I18n>(context, I18n);

  static Map<Locale, dynamic> _localizedValues = Map();

  static Future<I18n> load(Locale locale) async {
    I18n i18n = I18n(locale);
    for (Locale supportedLocale in supportedLocales) {
      String dict = await rootBundle.loadString(
          'locale/${supportedLocale.languageCode}' +
              (supportedLocale.scriptCode == null
                  ? ''
                  : '_${supportedLocale.scriptCode}') +
              '_${supportedLocale.countryCode}.json');
      _localizedValues[supportedLocale] = json.decode(dict);
    }
    return i18n;
  }

  String text(String key) {
    try {
      if (_localizedValues[locale].containsKey(key))
        return _localizedValues[locale][key].toString();
      return _localizedValues[supportedLocales.first][key].toString();
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }
}

class I18nDelegate extends LocalizationsDelegate<I18n> {
  const I18nDelegate();

  @override
  bool isSupported(Locale locale) => supportedLocales.contains(locale);

  @override
  Future<I18n> load(Locale locale) async => I18n.load(locale);

  @override
  bool shouldReload(I18nDelegate old) => false;
}

const Iterable<Locale> supportedLocales = [
  const Locale('en', 'US'),
  const Locale.fromSubtags(
      languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
];

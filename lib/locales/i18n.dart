import 'package:flutter/material.dart';
import 'package:bookshelf/locales/locale.dart';
import 'package:intl/intl.dart';

class I18n {
  I18n(this.locale);

  final Locale locale;

  static I18n of(BuildContext context) => Localizations.of<I18n>(context, I18n);

  static Map<Locale, Map<String, String>> _localizedValues = Map();

  static Future<I18n> load(Locale locale) async {
    I18n i18n = I18n(locale);
    _localizedValues = localeData;
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

  String dateFormat(DateTime dateTime) =>
      '${DateFormat.yMMMMd(locale.toString()).format(dateTime)} ${DateFormat.Hms(locale.toString()).format(dateTime)}';
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

Iterable<Locale> supportedLocales = localeData.keys;

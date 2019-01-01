import 'package:flutter/material.dart';

export 'package:bookshelf/locales/i18n.dart';
import 'package:bookshelf/locales/lang/en_US.dart' as en_US;
import 'package:bookshelf/locales/lang/zh_Hans_CN.dart' as zh_Hans_CN;

Map<Locale, Map<String, String>> localeData = {
  const Locale('en', 'US'): en_US.lang,
  const Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hans',
      countryCode: 'CN'): zh_Hans_CN.lang,
};

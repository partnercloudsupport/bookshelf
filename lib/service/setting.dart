import 'dart:convert';

import 'package:bookshelf/util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

getSettings() async {
  SharedPreferences pref = await sharedPreferences;
  try {
    return JSON.decode(pref.getString('settings'));
  } catch (_) {
    return {
      'manga-viewer': {
        'reader-method': 'scroll', // scroll, pageViewer
        'reader-direction': 'vertical-top', // vertical-top, vertical-down, horizontal-left, horizontal-right
        'picture-margin': 10,
        'autoload-preview-next': true,
      },
      'novel-viewer': {
        'reader-method': 'scroll', // scroll, pageViewer
        'reader-direction': 'horizontal-top', // horizontal-top, horizontal-down, vertical-left, vertical-right
        'background-color': '',
        'autoload-preview-next': true,
      },
      'general': {
        'keep-screen-on': false,
        'bookshelf-screen-direction': 'auto', // auto, fixed-left, fixed-right, fixed-up, fixed-down
        'record-search-keyword': true
      },
      'others': {
        'night-mode': false,
        'theme': ''
      }
    };
  }
}
setSettings(Map settings) async {
  (await sharedPreferences).setString('settings', JSON.encode(settings));
}

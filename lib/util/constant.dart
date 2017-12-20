import 'package:flutter/material.dart';

final String appname = 'bookshelf';
final String version = '0.1.0';

final ThemeData defaultTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

final ThemeData nightmodeTheme = new ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
);


final Map<String, String> ua = {
  'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.78 Safari/537.36',
};


Map basePageName = {
  'Bookshelf': '书架',
  'Manga': '漫画',
  'Novel': '小说',
  'Doujinshi': '同人志',
  'Themes': '主题',
  'Nightmode': '夜间模式',
  'Settings': '设置',
  'About': '关于',
};

getParserName(parserName) {
  switch (parserName) {
    case 'manga_dmzj': return '动漫之家';
    default: return parserName;
  }
}

availableParserList() {
  return ['manga_dmzj',];
}

//enum SourceType {
//  manga,
//  novel,
//  doujinshi,
//}

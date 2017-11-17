import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bookshelf/views/view_search.dart';
import 'package:bookshelf/views/view_detail.dart';
import 'package:bookshelf/views/manga_viewer.dart';
import 'package:bookshelf/views/novel_viewer.dart';
import 'package:bookshelf/views/view_settings.dart';
import 'package:bookshelf/views/view_about.dart';
import 'package:bookshelf/views/widgets/widget_bookshelf.dart';
import 'package:bookshelf/views/widgets/widget_doujinshi.dart';
import 'package:bookshelf/views/widgets/widget_manga.dart';
import 'package:bookshelf/views/widgets/widget_novel.dart';

routes(settings) {
  switch (settings.name.split('/')[1]) {
    case 'search': return new MaterialPageRoute(
      builder: (_) => new ViewSearch(),
      settings: settings,
    );
    case 'detail': return new MaterialPageRoute(
      builder: (_) => new ViewDetail(bookInfo: JSON.decode(settings.name.split('/')[2])),
      settings: settings,
    );
    case 'viewer~manga': return new MaterialPageRoute(
      builder: (_) => new MangaViewer(chapterInfo: JSON.decode(settings.name.split('/')[2])),
      settings: settings,
    );
    case 'viewer~novel': return new MaterialPageRoute(
      builder: (_) => new NovelViewer(chapterInfo: JSON.decode(settings.name.split('/')[2])),
      settings: settings,
    );
    case 'settings': return new MaterialPageRoute(
      builder: (_) => new ViewSettings(),
      settings: settings,
    );
    case 'about': return new MaterialPageRoute(
      builder: (_) => new ViewAbout(),
      settings: settings,
    );
    default: return new MaterialPageRoute(
      builder: (_) => new ViewAbout(),
      settings: settings,
    );
  }
}

Map tabbarLength = {
  'Bookshelf': 3,
  'Manga': 4,
  'Novel': 4,
  'Doujinshi': 4,
};
Map tabbarInitindex = {
  'Bookshelf': 0,
  'Manga': 2,
  'Novel': 2,
  'Doujinshi': 2,
};

tabbarItems(draweritemName) {
  switch (draweritemName) {
    case 'Bookshelf': return tabbarBookshelf();
    case 'Manga': return tabbarManga();
    case 'Novel': return tabbarNovel();
    case 'Doujinshi': return tabbarDoujinshi();
  }
}

bodyItems(draweritemName) {
  switch (draweritemName) {
    case 'Bookshelf': return new WidgetBookshelf();
    case 'Manga': return new WidgetManga();
    case 'Novel': return new WidgetNovel();
    case 'Doujinshi': return new WidgetDoujinshi();
  }
}

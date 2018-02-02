import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bookshelf/views/view_search.dart';
import 'package:bookshelf/views/view_manga_detail.dart';
import 'package:bookshelf/views/view_novel_detail.dart';
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
    case 'detail~manga': return new MaterialPageRoute(
      builder: (_) => new ViewMangaDetail(bookInfo: JSON.decode(settings.name.split('/')[2])),
      settings: settings,
    );
    case 'detail~novel': return new MaterialPageRoute(
      builder: (_) => new ViewNovelDetail(bookInfo: JSON.decode(settings.name.split('/')[2])),
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

//Map tabbarInitIndex = {
//  'Bookshelf': 0,
//  'Manga': 0,
//  'Novel': 0,
//  'Doujinshi': 0,
//};

tabbarItems(drawerItemName) {
  switch (drawerItemName) {
    case 'Bookshelf': return tabbarBookshelf();
    case 'Manga': return tabbarManga();
    case 'Novel': return tabbarNovel();
    case 'Doujinshi': return tabbarDoujinshi();
  }
}

bodyItems(drawerItemName) {
  switch (drawerItemName) {
    case 'Bookshelf': return new WidgetBookshelf();
    case 'Manga': return new WidgetManga();
    case 'Novel': return new WidgetNovel();
    case 'Doujinshi': return new WidgetDoujinshi();
  }
}

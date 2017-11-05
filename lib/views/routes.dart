import 'package:flutter/material.dart';
import 'package:bookshelf/views/view_search.dart';
import 'package:bookshelf/views/view_settings.dart';
import 'package:bookshelf/views/view_about.dart';
import 'package:bookshelf/views/widgets/widget_bookshelf.dart';
import 'package:bookshelf/views/widgets/widget_doujinshi.dart';
import 'package:bookshelf/views/widgets/widget_manga.dart';
import 'package:bookshelf/views/widgets/widget_novel.dart';

routes(settings) {
  switch (settings.name) {
    case '/search': return new MaterialPageRoute(
      builder: (_) => new ViewSearch(),
      settings: settings,
    );
    case '/settings': return new MaterialPageRoute(
      builder: (_) => new ViewSettings(),
      settings: settings,
    );
    case '/about': return new MaterialPageRoute(
      builder: (_) => new ViewAbout(),
      settings: settings,
    );
  }
}

Map tabbarLength = {
  'Bookshelf': 5,
  'Manga': 4,
  'Novel': 4,
  'Doujinshi': 4,
};

tabbarItems(draweritemName) {
  switch (draweritemName) {
    case 'Bookshelf': return tabbarBookshelf();
//    case 'Manga': return new WidgetManga();
//    case 'Novel': return new WidgetNovel();
//    case 'Doujinshi': return new WidgetDoujinshi();
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

import 'dart:convert';

import 'package:meta/meta.dart';
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
    case 'search': return new CustomPageRoute(
      builder: (_) => new ViewSearch(),
      settings: settings,
    );
    case 'detail~manga': return new CustomPageRoute(
      builder: (_) => new ViewMangaDetail(bookInfo: JSON.decode(settings.name.split('/')[2])),
      settings: settings,
    );
    case 'detail~novel': return new CustomPageRoute(
      builder: (_) => new ViewNovelDetail(bookInfo: JSON.decode(settings.name.split('/')[2])),
      settings: settings,
    );
    case 'viewer~manga': return new CustomPageRoute(
      builder: (_) => new MangaViewer(chapterInfo: JSON.decode(settings.name.split('/')[2])),
      settings: settings,
    );
    case 'viewer~novel': return new CustomPageRoute(
      builder: (_) => new NovelViewer(chapterInfo: JSON.decode(settings.name.split('/')[2])),
      settings: settings,
    );
    case 'settings': return new CustomPageRoute(
      builder: (_) => new ViewSettings(),
      settings: settings,
    );
    case 'about': return new CustomPageRoute(
      builder: (_) => new ViewAbout(),
      settings: settings,
    );
    default: return new CustomPageRoute(
      builder: (_) => new ViewAbout(),
      settings: settings,
    );
  }
}

class CustomPageRoute<T> extends MaterialPageRoute<T> {
  CustomPageRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return new _MountainViewPageTransition(
      routeAnimation: animation,
      child: child,
    );
  }
}
final Tween<Offset> _customTween = new Tween<Offset>(
  begin: const Offset(0.25, 0.0),
  end: Offset.zero,
);
class _MountainViewPageTransition extends StatelessWidget {
  _MountainViewPageTransition({
    Key key,
    @required Animation<double> routeAnimation,
    @required this.child,
  }) : _positionAnimation = _customTween.animate(new CurvedAnimation(
    parent: routeAnimation,
    curve: Curves.fastOutSlowIn,
  )),
        _opacityAnimation = const AlwaysStoppedAnimation<double>(1.0),
        super(key: key);

  final Animation<Offset> _positionAnimation;
  final Animation<double> _opacityAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new SlideTransition(
      position: _positionAnimation,
      child: new FadeTransition(
        opacity: _opacityAnimation,
        child: child,
      ),
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

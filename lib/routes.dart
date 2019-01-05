import 'package:flutter/material.dart';

import 'package:bookshelf/views/manga_detail.dart';
import 'package:bookshelf/views/doujinshi_detail.dart';
import 'package:bookshelf/views/theme.dart';
import 'package:bookshelf/views/settings.dart';
import 'package:bookshelf/views/about.dart';

Route getRoutes(RouteSettings settings) {
  switch (settings.name) {
    case '/manga_detail':
      return CustomPageRoute(builder: (context) => MangaDetailPage(), settings: settings);
    case '/doujinshi_detail':
      return CustomPageRoute(builder: (context) => DoujinshiDetailPage(), settings: settings);
    case '/theme':
      return CustomPageRoute(builder: (context) => ThemePage(), settings: settings);
    case '/settings':
      return CustomPageRoute(builder: (context) => SettingsPage(), settings: settings);
    case '/about':
      return CustomPageRoute(builder: (context) => AboutPage(), settings: settings);
    default:
      return CustomPageRoute(builder: (context) => AboutPage(), settings: settings);
  }
}

class CustomPageRoute<T> extends MaterialPageRoute<T> {
  CustomPageRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return _MountainViewPageTransition(
      routeAnimation: animation,
      child: child,
    );
  }
}

final Tween<Offset> _customTween = Tween<Offset>(
  begin: const Offset(0.25, 0.0),
  end: Offset.zero,
);

class _MountainViewPageTransition extends StatelessWidget {
  _MountainViewPageTransition({
    Key key,
    @required Animation<double> routeAnimation,
    @required this.child,
  })  : _positionAnimation = _customTween.animate(CurvedAnimation(
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
    return SlideTransition(
      position: _positionAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: child,
      ),
    );
  }
}

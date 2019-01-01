import 'package:bookshelf/models/model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:bookshelf/blocs/bloc.dart';
import 'package:bookshelf/locales/locale.dart';
import 'package:bookshelf/routes.dart';
import 'package:bookshelf/views/widgets/app_drawer.dart';
import 'package:bookshelf/views/manga_shelf.dart';
import 'package:bookshelf/views/doujinshi_shelf.dart';

class BookshelfApp extends StatelessWidget {
  final AppBloc _appBloc = AppBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _appBloc,
      child: BlocBuilder(
        bloc: _appBloc,
        builder: (BuildContext context, AppBlocState state) {
          return MaterialApp(
            localizationsDelegates: [
              const I18nDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: supportedLocales,
            localeResolutionCallback:
                (Locale locale, Iterable<Locale> supportedLocales) =>
                    supportedLocales.contains(locale)
                        ? locale
                        : supportedLocales.first,
            debugShowCheckedModeBanner: false,
            theme: state.currentThemeData,
            home: ShelfPage(),
            onGenerateRoute: (RouteSettings settings) => getRoutes(settings),
          );
        },
      ),
    );
  }
}

class ShelfPage extends StatefulWidget {
  ShelfPage({Key key}) : super(key: key);

  @override
  _ShelfPageState createState() => _ShelfPageState();
}

class _ShelfPageState extends State<ShelfPage> {
  final ShelfPageBloc _shelfPageBloc = ShelfPageBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShelfPageBloc>(
      bloc: _shelfPageBloc,
      child: Scaffold(
        body: BlocBuilder(
          bloc: _shelfPageBloc,
          builder: (BuildContext context, ShelfPageBlocState state) {
            switch (state.currentShelf) {
              case BookType.Manga:
                return MangaShelf();
              case BookType.Doujinshi:
                return DoujinshiShelf();
              default:
                return MangaShelf();
            }
          },
        ),
        drawer: AppDrawer(),
      ),
    );
  }

  @override
  void dispose() {
    _shelfPageBloc.dispose();
    super.dispose();
  }
}

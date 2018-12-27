import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookshelf/i18n.dart';
import 'package:bookshelf/routes.dart';
import 'package:bookshelf/blocs/bloc.dart';
import 'package:bookshelf/views/widgets/app_drawer.dart';
import 'package:bookshelf/views/manga_shelf.dart';
import 'package:bookshelf/views/doujinshi_shelf.dart';

class BookshelfApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        const I18nDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      localeResolutionCallback: (Locale locale,
              Iterable<Locale> supportedLocales) =>
          supportedLocales.contains(locale) ? locale : supportedLocales.first,
      debugShowCheckedModeBanner: false,
      title: 'Bookshelf',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BasePage(),
      onGenerateRoute: (RouteSettings settings) => routes(settings),
    );
  }
}

class BasePage extends StatefulWidget {
  BasePage({Key key}) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final BasePageBloc _basePageBloc = BasePageBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BasePageBloc>(
      bloc: _basePageBloc,
      child: Scaffold(
        body: BlocBuilder(
          bloc: _basePageBloc,
          builder: (BuildContext context, BasePageBlocState state) {
            return state.currentShelf == ShelfTypes.Manga
                ? MangaShelf()
                : DoujinshiShelf();
          },
        ),
        drawer: AppDrawer(),
      ),
    );
  }

  @override
  void dispose() {
    _basePageBloc.dispose();
    super.dispose();
  }
}

import 'package:bookshelf/blocs/bloc.dart';
import 'package:bookshelf/i18n.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BasePageBloc _basePageBloc = BlocProvider.of<BasePageBloc>(context);

    return BlocBuilder(
      bloc: _basePageBloc,
      builder: (BuildContext context, BasePageBlocState state) {
        return Drawer(
          child: Material(
            color: Theme.of(context).cardColor,
            child: ListView(
              padding: const EdgeInsets.only(top: 0.0),
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountEmail: null,
                  accountName: null,
                ),
                Material(
                  color: state.currentShelf == ShelfTypes.Manga
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).cardColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.view_carousel,
                      color: state.currentShelf == ShelfTypes.Manga
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).unselectedWidgetColor,
                    ),
                    title: Text(I18n.of(context).text('manga')),
                    onTap: () {
                      _basePageBloc.dispatch(DisplayMangaShelf());
                      Navigator.pop(context);
                    },
                  ),
                ),
                Material(
                  color: state.currentShelf == ShelfTypes.Doujinshi
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).cardColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.view_carousel,
                      color: state.currentShelf == ShelfTypes.Doujinshi
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).unselectedWidgetColor,
                    ),
                    title: Text(I18n.of(context).text('doujinshi')),
                    onTap: () {
                      _basePageBloc.dispatch(DisplayDoujinshiShelf());
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

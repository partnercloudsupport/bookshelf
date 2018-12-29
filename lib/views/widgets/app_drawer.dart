import 'package:bookshelf/blocs/bloc.dart';
import 'package:bookshelf/i18n.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ShelfPageBloc _shelfPageBloc = BlocProvider.of<ShelfPageBloc>(context);

    return BlocBuilder(
      bloc: _shelfPageBloc,
      builder: (BuildContext context, ShelfPageBlocState state) {
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
                      Icons.import_contacts,
                      color: state.currentShelf == ShelfTypes.Manga
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).unselectedWidgetColor,
                    ),
                    title: Text(I18n.of(context).text('manga')),
                    onTap: () {
                      _shelfPageBloc.dispatch(DisplayMangaShelf());
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
                      Icons.book,
                      color: state.currentShelf == ShelfTypes.Doujinshi
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).unselectedWidgetColor,
                    ),
                    title: Text(I18n.of(context).text('doujinshi')),
                    onTap: () {
                      _shelfPageBloc.dispatch(DisplayDoujinshiShelf());
                      Navigator.pop(context);
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: Text(I18n.of(context).text('search')),
                  onTap: () {
                    Navigator.of(context).pushNamed('/search');
                  },
                  selected: false,
                ),
                Divider(),
                ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: Text(I18n.of(context).text('theme')),
                  onTap: () {
                    Navigator.of(context).pushNamed('/theme');
                  },
                  selected: false,
                ),
                SwitchListTile(
                  title: Text(I18n.of(context).text('night_mode')),
                  secondary: const Icon(Icons.brightness_4),
                  value: false,
                  onChanged: (bool useNightmode) {
                    Navigator.pop(context);
                  },
                  activeColor: const Color(0xfff114b6),
                ),
                Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(I18n.of(context).text('settings')),
                  onTap: () {
                    Navigator.of(context).pushNamed('/settings');
                  },
                  selected: false,
                ),
                ListTile(
                  leading: const Icon(Icons.error),
                  title: Text(I18n.of(context).text('about')),
                  onTap: () {
                    Navigator.of(context).pushNamed('/about');
                  },
                  selected: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookshelf/blocs/bloc.dart';
import 'package:bookshelf/models/model.dart';
import 'package:bookshelf/locales/locale.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppBloc _appBloc = BlocProvider.of<AppBloc>(context);
    final ShelfPageBloc _shelfPageBloc =
        BlocProvider.of<ShelfPageBloc>(context);

    return Drawer(
      child: Material(
        color: Theme.of(context).cardColor,
        child: BlocBuilder(
          bloc: _shelfPageBloc,
          builder: (BuildContext context, state) {
            return ListView(
              padding: const EdgeInsets.only(top: 0.0),
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountEmail: null,
                  accountName: null,
                ),
                Material(
                  color: state.currentShelf == BookType.Manga
                      ? Theme.of(context).primaryColorLight.withAlpha(150)
                      : Theme.of(context).cardColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.import_contacts,
                      color: state.currentShelf == BookType.Manga
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).unselectedWidgetColor,
                    ),
                    title: Text(
                      I18n.of(context).text('manga'),
                      style: TextStyle(
                        color: state.currentShelf == BookType.Manga
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).unselectedWidgetColor,
                      ),
                    ),
                    onTap: () {
                      _shelfPageBloc.dispatch(SetCurrentShelf(BookType.Manga));
                      Navigator.pop(context);
                    },
                  ),
                ),
                Material(
                  color: state.currentShelf == BookType.Doujinshi
                      ? Theme.of(context).primaryColorLight.withAlpha(150)
                      : Theme.of(context).cardColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.book,
                      color: state.currentShelf == BookType.Doujinshi
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).unselectedWidgetColor,
                    ),
                    title: Text(
                      I18n.of(context).text('doujinshi'),
                      style: TextStyle(
                        color: state.currentShelf == BookType.Doujinshi
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).unselectedWidgetColor,
                      ),
                    ),
                    onTap: () {
                      _shelfPageBloc
                          .dispatch(SetCurrentShelf(BookType.Doujinshi));
                      Navigator.pop(context);
                    },
                  ),
                ),
                // Material(
                //   color: Theme.of(context).cardColor,
                //   child: ListTile(
                //     leading: Icon(
                //       Icons.photo,
                //     ),
                //     title: Text(
                //       I18n.of(context).text('illustration'),
                //     ),
                //     onTap: () {
                //       Navigator.pop(context);
                //     },
                //   ),
                // ),
                Divider(),
                ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: Text(
                    I18n.of(context).text('theme'),
                    style: TextStyle(
                      color: Theme.of(context).unselectedWidgetColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/theme');
                  },
                  selected: false,
                ),
                BlocBuilder(
                  bloc: _appBloc,
                  builder: (BuildContext context, AppBlocState state) {
                    return SwitchListTile(
                      title: Text(
                        I18n.of(context).text('night_mode'),
                        style: TextStyle(
                          color: Theme.of(context).unselectedWidgetColor,
                        ),
                      ),
                      secondary: const Icon(Icons.brightness_4),
                      value: state.nightMode,
                      onChanged: (bool value) {
                        _appBloc.dispatch(UseNightMode(value));
                      },
                      activeColor: const Color(0xfff114b6),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(
                    I18n.of(context).text('settings'),
                    style: TextStyle(
                      color: Theme.of(context).unselectedWidgetColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/settings');
                  },
                  selected: false,
                ),
                ListTile(
                  leading: const Icon(Icons.error),
                  title: Text(
                    I18n.of(context).text('about'),
                    style: TextStyle(
                      color: Theme.of(context).unselectedWidgetColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/about');
                  },
                  selected: false,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

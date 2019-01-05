import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookshelf/blocs/bloc.dart';
import 'package:bookshelf/models/model.dart';
import 'package:bookshelf/locales/locale.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    final ShelfPageBloc shelfPageBloc = BlocProvider.of<ShelfPageBloc>(context);
    final ThemeData theme = Theme.of(context);
    final I18n i18n = I18n.of(context);

    return Drawer(
      child: Material(
        color: theme.cardColor,
        child: BlocBuilder(
          bloc: shelfPageBloc,
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
                      ? theme.primaryColorLight.withAlpha(150)
                      : theme.cardColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.import_contacts,
                      color: state.currentShelf == BookType.Manga
                          ? theme.primaryColor
                          : theme.unselectedWidgetColor,
                    ),
                    title: Text(
                      i18n.text('manga'),
                      style: TextStyle(
                        color: state.currentShelf == BookType.Manga
                            ? theme.primaryColor
                            : theme.unselectedWidgetColor,
                      ),
                    ),
                    onTap: () {
                      shelfPageBloc.dispatch(SetCurrentShelf(BookType.Manga));
                      Navigator.pop(context);
                    },
                  ),
                ),
                Material(
                  color: state.currentShelf == BookType.Doujinshi
                      ? theme.primaryColorLight.withAlpha(150)
                      : theme.cardColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.book,
                      color: state.currentShelf == BookType.Doujinshi
                          ? theme.primaryColor
                          : theme.unselectedWidgetColor,
                    ),
                    title: Text(
                      i18n.text('doujinshi'),
                      style: TextStyle(
                        color: state.currentShelf == BookType.Doujinshi
                            ? theme.primaryColor
                            : theme.unselectedWidgetColor,
                      ),
                    ),
                    onTap: () {
                      shelfPageBloc
                          .dispatch(SetCurrentShelf(BookType.Doujinshi));
                      Navigator.pop(context);
                    },
                  ),
                ),
                Material(
                  color: state.currentShelf == BookType.Illustration
                      ? theme.primaryColorLight.withAlpha(150)
                      : theme.cardColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.photo,
                      color: state.currentShelf == BookType.Illustration
                          ? theme.primaryColor
                          : theme.unselectedWidgetColor,
                    ),
                    title: Text(
                      i18n.text('illustration'),
                      style: TextStyle(
                        color: state.currentShelf == BookType.Illustration
                            ? theme.primaryColor
                            : theme.unselectedWidgetColor,
                      ),
                    ),
                    onTap: () {
                      shelfPageBloc
                          .dispatch(SetCurrentShelf(BookType.Illustration));
                      Navigator.pop(context);
                    },
                  ),
                ),
                Divider(),
                ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: Text(
                    i18n.text('theme'),
                    style: TextStyle(
                      color: theme.unselectedWidgetColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/theme');
                  },
                  selected: false,
                ),
                BlocBuilder(
                  bloc: appBloc,
                  builder: (BuildContext context, AppBlocState state) {
                    return SwitchListTile(
                      title: Text(
                        i18n.text('night_mode'),
                        style: TextStyle(
                          color: theme.unselectedWidgetColor,
                        ),
                      ),
                      secondary: const Icon(Icons.brightness_4),
                      value: state.nightMode,
                      onChanged: (bool value) {
                        appBloc.dispatch(UseNightMode(value));
                      },
                      activeColor: theme.primaryColor,
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(
                    i18n.text('settings'),
                    style: TextStyle(
                      color: theme.unselectedWidgetColor,
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
                    i18n.text('about'),
                    style: TextStyle(
                      color: theme.unselectedWidgetColor,
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

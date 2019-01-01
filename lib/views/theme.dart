import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookshelf/blocs/bloc.dart';
import 'package:bookshelf/locales/locale.dart';

class ThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppBloc _appBloc = BlocProvider.of<AppBloc>(context);

    changeTheme(ThemeData themeData) =>
        _appBloc.dispatch(SetCurrentTheme(themeData));

    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).text('theme')),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FlatButton(
              color: Colors.blue,
              child: Icon(Icons.color_lens),
              onPressed: () => changeTheme(ThemeData(
                    primaryColor: Colors.blue,
                  )),
            ),
            FlatButton(
              color: Colors.cyan,
              child: Icon(Icons.color_lens),
              onPressed: () => changeTheme(ThemeData(
                    primaryColor: Colors.cyan,
                  )),
            ),
            FlatButton(
              color: Colors.yellow,
              child: Icon(Icons.color_lens),
              onPressed: () => changeTheme(ThemeData(
                    primaryColor: Colors.yellow,
                  )),
            ),
            FlatButton(
              color: Colors.green,
              child: Icon(Icons.color_lens),
              onPressed: () => changeTheme(ThemeData(
                    primaryColor: Colors.green,
                  )),
            ),
            FlatButton(
              color: Colors.red,
              child: Icon(Icons.color_lens),
              onPressed: () => changeTheme(ThemeData(
                    primaryColor: Colors.red,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

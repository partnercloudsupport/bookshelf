import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:bookshelf/util/constant.dart';
import 'package:bookshelf/views/routes.dart';
import 'package:bookshelf/views/widgets/widget_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookshelfApp extends StatefulWidget {
  const BookshelfApp({Key key}) : super(key: key);

  @override
  BookshelfAppState createState() => new BookshelfAppState();
}

class BookshelfAppState extends State<BookshelfApp> {
  bool _useNightmode = false;
  String _draweritemSelected = 'Bookshelf';

  @override
  void initState() {
    super.initState();
    _getNightmodePreference();
  }

  _getNightmodePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('usenightmode') ?? false) {
      setState(() => _useNightmode = true);
    }
  }
  _setNightmodePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('usenightmode', _useNightmode);
  }

  @override
  Widget build(BuildContext context) {
    Widget home = new BasePage(
        useNightmode: _useNightmode,
        onNightmodeChanged: (bool value) => setState(() {
          _useNightmode = value;
          _setNightmodePreference();
        }),
        draweritemSelected: _draweritemSelected,
        ondraweritemSelected: (String value) => setState(() {_draweritemSelected = value;}),
    );

    return new MaterialApp(
      theme: _useNightmode ? nightmodeTheme : defaultTheme,
      home: home,
      onGenerateRoute: (RouteSettings settings) => routes(settings),
    );
  }
}


class BasePage extends StatefulWidget {
  const BasePage({
    Key key,
    this.useNightmode: false,
    @required this.onNightmodeChanged,
    this.draweritemSelected: 'Bookshelf',
    @required this.ondraweritemSelected,
  }) : super(key: key);

  final bool useNightmode;
  final ValueChanged<bool> onNightmodeChanged;
  final String draweritemSelected;
  final ValueChanged<String> ondraweritemSelected;

  @override
  _BasePageState createState() => new _BasePageState();
}

class _BasePageState extends State<BasePage> {

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: tabbarLength[widget.draweritemSelected],
        initialIndex: tabbarInitindex[widget.draweritemSelected],
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text(basePageName[widget.draweritemSelected]),
            actions: <Widget>[
              new IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.of(context).pushNamed('/search');
                },
              ),
            ],
            bottom: tabbarItems(widget.draweritemSelected),
//            elevation: 0.0,
          ),
          drawer: new WidgetDrawer(
            useNightmode: widget.useNightmode,
            onNightmodeChanged: widget.onNightmodeChanged,
            draweritemSelected: widget.draweritemSelected,
            ondraweritemSelected: widget.ondraweritemSelected,
          ),
          body: bodyItems(widget.draweritemSelected),
        ),
    );
  }
}

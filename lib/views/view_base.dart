import 'package:bookshelf/database/db.dart';
import 'package:bookshelf/util/eventbus.dart';
import 'package:bookshelf/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:bookshelf/util/constant.dart';
import 'package:bookshelf/views/routes.dart';
import 'package:bookshelf/views/widgets/widget_drawer.dart';
import 'package:bookshelf/service/setting.dart';

class BookshelfApp extends StatefulWidget {
  const BookshelfApp({Key key}) : super(key: key);

  @override
  BookshelfAppState createState() => new BookshelfAppState();
}

class BookshelfAppState extends State<BookshelfApp> {
  Map settings;
  String _drawerItemSelected = 'Bookshelf';

  @override
  initState() {
    super.initState();
    final QuickActions quickActions = const QuickActions();
    quickActions.initialize((String shortcutType) {
      if (shortcutType == 'search') {
        Navigator.of(context).pushNamed('/search');
      }
    });
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(type: 'search', localizedTitle: '搜索', icon: 'icon_search'),
    ]);
    getSettings().then((Map data) => setState(() => settings = data));
  }

  @override
  Widget build(BuildContext context) {
    Widget home = new BasePage(
        useNightmode: settings != null ? settings['others']['night-mode'] : false,
        onNightmodeChanged: (bool val) => setState(() {
          settings['others']['night-mode'] = val;
          setSettings(settings);
        }),
        drawerItemSelected: _drawerItemSelected,
        onDrawerItemSelected: (String val) => setState(() {_drawerItemSelected = val;}),
    );

    return new MaterialApp(
      theme: (settings != null ? settings['others']['night-mode'] : false) ? nightmodeTheme : defaultTheme,
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
    this.drawerItemSelected: 'Bookshelf',
    @required this.onDrawerItemSelected,
  }) : super(key: key);

  final bool useNightmode;
  final ValueChanged<bool> onNightmodeChanged;
  final String drawerItemSelected;
  final ValueChanged<String> onDrawerItemSelected;

  @override
  _BasePageState createState() => new _BasePageState();
}

class _BasePageState extends State<BasePage> {
  Db _db = new Db(() { bus.fire('load_drawerheader'); });
  Map recentBook;
  Map cachedResult;

  _getRecentBook([Function val()]) async {
    if (val != null) {
      recentBook = val(); // ignore: invalid_assignment
    } else {
      recentBook = await _db.get('recent_book');
    }
    setState((){});
  }

  @override
  initState() {
    super.initState();
    bus.listen('load_drawerheader', _getRecentBook);
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: tabbarItems(widget.drawerItemSelected).tabs.length,
//        initialIndex: tabbarInitindex[widget.draweritemSelected],
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text(basePageName[widget.drawerItemSelected]),
            actions: <Widget>[
              new IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.of(context).pushNamed('/search');
                },
              ),
            ],
            bottom: tabbarItems(widget.drawerItemSelected),
//            elevation: 0.0,
          ),
          drawer: new WidgetDrawer(
            useNightmode: widget.useNightmode,
            onNightmodeChanged: widget.onNightmodeChanged,
            drawerItemSelected: widget.drawerItemSelected,
            onDrawerItemSelected: widget.onDrawerItemSelected,
            recentBook: recentBook,
          ),
          body: bodyItems(widget.drawerItemSelected),
        ),
    );
  }
}

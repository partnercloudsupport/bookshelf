import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:bookshelf/util/constant.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';

class WidgetDrawer extends StatelessWidget {
  WidgetDrawer({
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

  _toggleNightmode() {
    onNightmodeChanged(!useNightmode);
  }
  void _tapDrawerItem(drawerItemName) => onDrawerItemSelected(drawerItemName);

  _drawerItemSelectedColor(context, drawerItemName) {
    return drawerItemSelected == drawerItemName
        ? (useNightmode ? const Color(0xff808080) : const Color(0xffefefef))
        : Theme.of(context).cardColor;
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new Material(
        color: Theme.of(context).cardColor,
        child: new ListView(
          padding: const EdgeInsets.only(top: 0.0),
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text('书架', style: new TextStyle(fontSize: 15.0),),
              accountEmail: new Text('找本书看看吧', style: new TextStyle(fontSize: 12.0),),
              decoration: new BoxDecoration(
                color: const Color(0xfff114b6),
                image: null,
                border: null,
              ),
            ),
            new Material(
              color: _drawerItemSelectedColor(context, 'Bookshelf'),
              child: new ListTile(
                leading: const Icon(Icons.view_comfy),
                title: new Text(basePageName['Bookshelf']),
                onTap: () {
                  Navigator.pop(context);
                  _tapDrawerItem('Bookshelf');
                },
                selected: drawerItemSelected == 'Bookshelf',
              ),
            ),
            new Material(
              color: _drawerItemSelectedColor(context, 'Manga'),
              child: new ListTile(
                leading: const Icon(Icons.import_contacts),
                title: new Text(basePageName['Manga']),
                onTap: () {
                  Navigator.pop(context);
                  _tapDrawerItem('Manga');
                },
                selected: drawerItemSelected == 'Manga',
              ),
            ),
            new Material(
              color: _drawerItemSelectedColor(context, 'Novel'),
              child: new ListTile(
                leading: const Icon(Icons.chrome_reader_mode),
                title: new Text(basePageName['Novel']),
                onTap: () {
                  Navigator.pop(context);
                  _tapDrawerItem('Novel');
                },
                selected: drawerItemSelected == 'Novel',
              ),
            ),
            new Material(
              color: _drawerItemSelectedColor(context, 'Doujinshi'),
              child: new ListTile(
                leading: const Icon(Icons.battery_charging_full),
                title: new Text(basePageName['Doujinshi']),
                onTap: () {
                  Navigator.pop(context);
                  _tapDrawerItem('Doujinshi');
                },
                selected: drawerItemSelected == 'Doujinshi',
              ),
            ),
            new Divider(),
//            new ListTile(
//              leading: const Icon(Icons.color_lens),
//              title: new Text(basePageName['Themes']),
//              onTap: () {},
//            ),
            new SwitchListTile(
              title: new Text(basePageName['Nightmode']),
              secondary: const Icon(Icons.brightness_4),
              value: useNightmode,
              onChanged: (useNightmode) {
                Navigator.pop(context);
                _toggleNightmode();
              },
              activeColor: const Color(0xfff114b6),
            ),
            new Divider(),
            new ListTile(
              leading: const Icon(Icons.settings),
              title: new Text(basePageName['Settings']),
              onTap: () {
                Navigator.of(context).pushNamed('/settings');
              },
              selected: false,
            ),
            new ListTile(
              leading: const Icon(Icons.error),
              title: new Text(basePageName['About']),
              onTap: () {
                Navigator.of(context).pushNamed('/about');
              },
              selected: false,
            ),
          ],
        ),
      )
    );
  }
}

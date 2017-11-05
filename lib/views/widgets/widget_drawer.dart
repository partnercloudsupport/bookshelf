import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class WidgetDrawer extends StatelessWidget {
  WidgetDrawer({
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

  _toggleNightmode() {
    onNightmodeChanged(!useNightmode);
  }
  void _tapDraweritem(draweritemName) => ondraweritemSelected(draweritemName);

  _draweritemselectedColor(context, draweritemName) {
    return draweritemSelected == draweritemName ? (useNightmode ? const Color(0xff808080) : const Color(0xffefefef)) : Theme.of(context).cardColor;
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: const Text('fuyumi'),
            accountEmail: const Text('fuyumi@example.com'),
            decoration: new BoxDecoration(
              color: const Color(0xfff114b6),
              image: null,
              border: null,
            ),
          ),
          new Material(
            color: _draweritemselectedColor(context, 'Bookshelf'),
            child: new ListTile(
              leading: const Icon(Icons.view_comfy),
              title: const Text('Bookshelf'),
              onTap: () {
                Navigator.pop(context);
                _tapDraweritem('Bookshelf');
              },
              selected: draweritemSelected == 'Bookshelf',
            ),
          ),
          new Material(
            color: _draweritemselectedColor(context, 'Manga'),
            child: new ListTile(
              leading: const Icon(Icons.import_contacts),
              title: const Text('Manga'),
              onTap: () {
                Navigator.pop(context);
                _tapDraweritem('Manga');
              },
              selected: draweritemSelected == 'Manga',
            ),
          ),
          new Material(
            color: _draweritemselectedColor(context, 'Novel'),
            child: new ListTile(
              leading: const Icon(Icons.chrome_reader_mode),
              title: const Text('Novel'),
              onTap: () {
                Navigator.pop(context);
                _tapDraweritem('Novel');
              },
              selected: draweritemSelected == 'Novel',
            ),
          ),
          new Material(
            color: _draweritemselectedColor(context, 'Doujinshi'),
            child: new ListTile(
              leading: const Icon(Icons.battery_charging_full),
              title: const Text('Doujinshi'),
              onTap: () {
                Navigator.pop(context);
                _tapDraweritem('Doujinshi');
              },
              selected: draweritemSelected == 'Doujinshi',
            ),
          ),
          new Divider(),
          new ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Themes'),
            onTap: () {},
          ),
          new SwitchListTile(
            secondary: const Icon(Icons.brightness_4),
            title: const Text('Nightmode'),
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
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pushNamed('/settings');
            },
            selected: false,
          ),
          new ListTile(
            leading: const Icon(Icons.error),
            title: const Text('About'),
            onTap: () {
              Navigator.of(context).pushNamed('/about');
            },
            selected: false,
          ),
        ],
      ),
    );
  }
}

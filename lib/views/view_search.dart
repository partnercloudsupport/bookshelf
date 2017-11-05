import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewSearch extends StatefulWidget {
  const ViewSearch({Key key}) : super(key: key);

  @override
  ViewSearchState createState() => new ViewSearchState();
}

class ViewSearchState extends State<ViewSearch> {
  List<String> searchList = [];
  bool showClearTextBtn = false;
  TextEditingController controller = new TextEditingController();
  bool showSearchhistory = false;
  bool showSearchresult = false;

  @override
  void initState() {
    super.initState();
    _getSearchhistoryPreference();
    controller.addListener(() =>
        setState(() => showClearTextBtn = controller.text.isNotEmpty));
  }

  _getSearchhistoryPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => searchList = prefs.getStringList('searchhistory') ?? []);
  }

  _setSearchhistoryPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('searchhistory', searchList);
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  key: new Key('SearchBarTextField'),
                  keyboardType: TextInputType.text,
                  style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white70,
                  ),
                  decoration: new InputDecoration(
                    hintText: 'Search something',
                    hintStyle: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.white30,
                    ),
                    hideDivider: true,
                  ),
                  autofocus: true,
                  autocorrect: false,
                  controller: controller,
                  onChanged: (String val) {
                    setState(() {
                      showSearchhistory = val.isNotEmpty;
                    });
                  },
                  onSubmitted: (String val) => beginSearch(val),
                ),
              ),
              showClearTextBtn ? new IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.text = '';
                    setState(() {
                      showSearchhistory = false;
                    });
                  }
              ) : new Container(),
            ],
          ),
          bottom: showSearchresult ? new TabBar(
            tabs: <Widget>[
              new Tab(text: 'Manga'),
              new Tab(text: 'Novel'),
              new Tab(text: 'Doujinshi'),
            ],
          ) : null,
        ),
        body: new Stack(
          children: <Widget>[
            new ListView(
              padding: const EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
              children: showSearchhistory ? historyItems(searchList) : <Widget>[
              ],
            ),
          ],
        ),
      ),
    );
  }

  beginSearch(String val) {
    if (val.isNotEmpty) {
      setState(() {
        showSearchhistory = false;
        showSearchresult = true;
        if (!searchList.contains(val)) {
          searchList.add(val);
          _setSearchhistoryPreference();
        }
      });
      print(searchList);
    }
  }

  historyItems(List<String> items) {
    return []
      ..add(new Material(
        child: historyItem(context, controller.text, true),
        color: Theme
            .of(context)
            .cardColor,
      ))
      ..addAll(items.map((String val) {
        return new Material(
          child: historyItem(context, val),
          color: Theme
              .of(context)
              .cardColor,
        );
      })
          .toList()
          .reversed);
  }

  Row historyItem(BuildContext context, String item,
      [bool notHistoryitem = false]) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new ListTileTheme(
            child: new ListTile(
              leading: notHistoryitem ? null : const Icon(Icons.history),
              title: notHistoryitem
                  ? new Text('Search "' + item + '"')
                  : new Text(item),
              onTap: () => beginSearch(item),
            ),
            textColor: notHistoryitem ? Theme
                .of(context)
                .accentColor : null,
          ),
        ),
        notHistoryitem ? new Container() : new IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() => searchList.remove(item));
            _setSearchhistoryPreference();
          },
        ),
      ],
    );
  }

}

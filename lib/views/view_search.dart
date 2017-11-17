import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookshelf/service/parse/parser.dart';
import 'package:bookshelf/util/image_provider.dart';
import 'package:bookshelf/util/constant.dart';

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

  List<String> parsersName = ['manga_dmzj'];
  Parser parser = new Parser();
  List searchMangaResult = [];

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
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.setStringList('searchhistory', searchList);
  }

  _clearSearchhistoryPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  _getSearchResult(keyword) {
    List parsersList = parserSelector(parsersName);
    List results = parser.searchBooks(parsersList, keyword);
    results.forEach((var res) async {
      List result = await res;
      setState(() => searchMangaResult.addAll(result));
      result.forEach((Map<String, String> val){
        if (!val['title'].contains(keyword)) {
          setState(() => searchMangaResult.remove(val));
        }
      });
    });
  }

  Future<Null> _refreshHandle() {
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(milliseconds: 200), () {
      completer.complete(beginSearch(controller.text));
    });
    return completer.future.then((_) {});
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
            new TabBarView(
              children: <Widget>[
                resultItems(context, searchMangaResult),
                resultItems(context, []),
                resultItems(context, []),
              ],
            ),
//            new ListView(
//              padding: const EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
//              children: showSearchhistory
//                  ? historyItems(searchList)
//                  : <Widget>[],
//            ),
          ],
        ),
      ),
    );
  }

  resultItems(BuildContext context, List resultList) {
    return new RefreshIndicator(
        child: new ListView(
          children: resultList.map((Map result) {
            return new Container(
              margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
              child: new Material(
                color: Theme.of(context).cardColor,
                child: new InkWell(
                  onTap: () {
                    Map val = {
                      'id': result['id'],
                      'title': result['title'],
                      'parser': result['parser'],
                      'type': result['type'],
                    };
                    Navigator.of(context).pushNamed('/detail/' + JSON.encode(val));
                  },
                  child: new Container(
                    height: 110.0,
                    margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          height: 110.0,
                          width: 80.0,
                          margin: const EdgeInsets.only(right: 15.0),
                          child: new Image(
                            height: 110.0,
                            image: new NetworkImageWithRetry(result['coverurl'], header: result['coverurl_header']),
                          ),
                        ),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Text(result['title'],
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              new Text(result['authors'],
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              new Text(result['types'],
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              new Text(result['status'],
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              new Text(result['last_chapter'],
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        new SizedBox(
                          height: 100.0,
                          width: 80.0,
                          child: new Column(
                            children: <Widget>[
                              new Text(getParserName(result['parser']),
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        onRefresh: _refreshHandle,
    );
  }

  beginSearch(String val) {
    setState(() => searchMangaResult = []);
    if (val.isNotEmpty) {
      _getSearchResult(val);
      setState(() {
        showSearchhistory = false;
        showSearchresult = true;
        if (!searchList.contains(val)) {
          try {
            searchList.add(val);
          } catch (e) {
            _clearSearchhistoryPreference();
          } finally {
            _setSearchhistoryPreference();
          }
        }
      });
//      print(searchList);
    }
  }

  historyItems(List<String> items) {
    return []
      ..add(new Material(
        child: historyItem(context, controller.text, true),
        color: Theme.of(context).cardColor,
      ))
      ..addAll(items.map((String val) {
        return new Material(
          child: historyItem(context, val),
          color: Theme.of(context).cardColor,
        );
      }).toList().reversed);
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
            textColor: notHistoryitem
                ? Theme.of(context).accentColor
                : null,
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

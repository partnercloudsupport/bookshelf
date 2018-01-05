import 'dart:async';
import 'dart:convert';

import 'package:bookshelf/util/util.dart';
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
  bool showSearchHistory = false;
  bool showSearchResult = false;
  ScrollController _scrollController = new ScrollController();

  List<String> parsersName = availableParserList();
  Parser parser = new Parser();
  List searchMangaResult = [];
  List searchNovelResult = [];
  List searchDoujinshiResult = [];

  @override
  void initState() {
    super.initState();
    _getSearchHistoryPreference();
    controller.addListener(() =>
        setState(() => showClearTextBtn = controller.text.isNotEmpty));
  }

  _getSearchHistoryPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => searchList.addAll(prefs.getStringList('searchhistory') ?? []));
  }

  _setSearchHistoryPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('searchhistory', searchList);
  }

  _clearSearchHistoryPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  /// TODO: Incremental search
  _getSearchResult(keyword) {
    Map parsersList = parserSelector(parsersName);
    List mangaResults = parser.searchBooks(parsersList['manga'], keyword);
    List novelResults = parser.searchBooks(parsersList['novel'], keyword);
    List doujinshiResults = parser.searchBooks(parsersList['doujinshi'], keyword);
    mangaResults.forEach((var res) async {
      List result = await res;
      setState(() => searchMangaResult.addAll(result));
      result.forEach((Map<String, String> val){
        if (!val['title'].contains(keyword)) {
          setState(() => searchMangaResult.remove(val));
        }
      });
    });
    novelResults.forEach((var res) async {
      List result = await res;
      setState(() => searchNovelResult.addAll(result));
      result.forEach((Map<String, String> val){
        if (!val['title'].contains(keyword)) {
          setState(() => searchNovelResult.remove(val));
        }
      });
    });
    doujinshiResults.forEach((var res) async {
      List result = await res;
      setState(() => searchDoujinshiResult.addAll(result));
      result.forEach((Map<String, String> val){
        if (!val['title'].contains(keyword)) {
          setState(() => searchDoujinshiResult.remove(val));
        }
      });
    });
  }

  Future<Null> _refreshHandle() {
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(milliseconds: 200), () {
      completer.complete(beginSearch(controller.text));
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
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
                    hintText: '找本书看看吧',
                    hintStyle: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.white30,
                    ),
                    hideDivider: true,
                  ),
                  autofocus: false,
                  autocorrect: false,
                  controller: controller,
                  onChanged: (String val) => setState(() => showSearchHistory = val.isNotEmpty),
                  onSubmitted: (String val) => beginSearch(val),
                ),
              ),
              showClearTextBtn ? new IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.text = '';
                    setState(() {
                      showSearchHistory = false;
                    });
                  }
              ) : new Container(),
            ],
          ),
        ),
        body: new CustomMultiChildLayout(
          delegate: new _ViewSearchLayout(),
          children: <Widget>[
            new LayoutId(
              id: _ViewSearchLayout.searchPage,
              child: new TabBarView(
                children: <Widget>[
                  resultItems(context, searchMangaResult),
                  resultItems(context, searchNovelResult),
                  resultItems(context, []),
                ],
              ),
            ),
            new LayoutId(
              id: _ViewSearchLayout.searchTabbar,
              child: showSearchResult ? new Material(
                color: Theme.of(context).primaryColor,
                elevation: 8.0,
                child: new TabBar(
                  tabs: <Widget>[
                    new Tab(text: '漫画'),
                    new Tab(text: '小说'),
                    new Tab(text: '同人志'),
                  ],
                ),
              ) : new Container(),
            ),
            new LayoutId(
              id: _ViewSearchLayout.searchPanel,
              child: new Column(
                children: showSearchHistory
                    ? historyItems(searchList)
                    : <Widget>[],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget resultItems(BuildContext context, List resultList) {
    return new RefreshIndicator(
      child: new ListView.builder(
        controller: _scrollController,
        itemCount: resultList.length,
        itemBuilder: (BuildContext context, int index) {
          Map result = resultList[index];
          return new Container(
            margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
            child: new Material(
              child: new InkWell(
                onTap: () {
                  Map val = {
                    'id': result['id'],
                    'title': result['title'],
                    'parser': result['parser'],
                    'type': result['type'],
                  };
                  (result['type'] == 'novel')
                      ? Navigator.of(context).pushNamed('/detail~novel/' + JSON.encode(val))
                      : Navigator.of(context).pushNamed('/detail~manga/' + JSON.encode(val));
                },
                child: new Container(
                  height: 120.0,
                  margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        height: 120.0,
                        width: 100.0,
                        margin: const EdgeInsets.only(right: 15.0),
                        child: new Image(
                          height: 120.0,
                          image: new AdvancedNetworkImage(result['coverurl'], header: result['coverurl_header']),
                          fit: BoxFit.cover,
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
                                color: invertColor(Theme.of(context).cardColor.withOpacity(0.54)),
                              ),
                            ),
                            new Text(result['types'],
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                color: invertColor(Theme.of(context).cardColor.withOpacity(0.54)),
                              ),
                            ),
                            new Text(result['status'],
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                color: invertColor(Theme.of(context).cardColor.withOpacity(0.54)),
                              ),
                            ),
                            new Text(result['last_chapter'],
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                color: invertColor(Theme.of(context).cardColor.withOpacity(0.54)),
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
                                color: invertColor(Theme.of(context).cardColor.withOpacity(0.54)),
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
        },
      ),
      onRefresh: _refreshHandle,
    );
  }

  beginSearch(String val) {
    setState(() => searchMangaResult = []);
    if (val.isNotEmpty) {
      _getSearchResult(val);
      setState(() {
        showSearchHistory = false;
        showSearchResult = true;
        if (!searchList.contains(val)) {
          try {
            searchList.add(val);
          } catch (e) {
            _clearSearchHistoryPreference();
            print(e);
          } finally {
            _setSearchHistoryPreference();
          }
        }
      });
//      print(searchList);
    }
  }

  List<Widget> historyItems(List<String> items) {
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

  Widget historyItem(BuildContext context, String item, [bool notHistoryItem = false]) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new ListTileTheme(
            child: new ListTile(
              leading: notHistoryItem ? null : const Icon(Icons.history),
              title: notHistoryItem
                  ? new Text('搜索 "' + item + '"')
                  : new Text(item),
              onTap: () {
                setState(() => this.controller.text = item);
                beginSearch(item);
              },
            ),
            textColor: notHistoryItem
                ? Theme.of(context).accentColor
                : null,
          ),
        ),
        notHistoryItem ? new Container() : new IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() => searchList.remove(item));
            _setSearchHistoryPreference();
          },
        ),
      ],
    );
  }
}

class _ViewSearchLayout extends MultiChildLayoutDelegate {
  _ViewSearchLayout();

  static final String searchPanel = 'searchpanel';
  static final String searchPage = 'searchpage';
  static final String searchTabbar = 'searchtabbar';

  @override
  void performLayout(Size size) {
    layoutChild(searchPanel, new BoxConstraints.tightForFinite(width: size.width - 120.0, height: double.infinity));
    positionChild(searchPanel, new Offset(60.0, 0.0));
    layoutChild(searchTabbar, new BoxConstraints.tightFor(width: size.width, height: 50.0));
    positionChild(searchTabbar, Offset.zero);
    layoutChild(searchPage, new BoxConstraints.tightFor(width: size.width, height: size.height - 50.0));
    positionChild(searchPage, new Offset(0.0, 50.0));
  }

  @override
  bool shouldRelayout(_ViewSearchLayout oldDelegate) => false;
}

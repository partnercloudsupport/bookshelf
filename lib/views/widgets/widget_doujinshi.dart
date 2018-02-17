import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:flutter_advanced_networkimage/transition_to_image.dart';
import 'package:bookshelf/database/db.dart';
import 'package:bookshelf/util/eventbus.dart';
import 'package:bookshelf/util/util.dart';

class WidgetDoujinshi extends StatefulWidget {
  const WidgetDoujinshi({ Key key }) : super(key: key);

  @override
  WidgetDoujinshiState createState() => new WidgetDoujinshiState();
}

class WidgetDoujinshiState extends State<WidgetDoujinshi> {
  Db _db = defaultDb;
  Map cachedResult;
  Map bookHistory;
  Map bookFavored;

  @override
  initState() {
    super.initState();
    _loadBooks();
    bus.listen('reload_bookshelf', _refreshHandle);
  }
  @override
  dispose() {
    bus.leave('reload_bookshelf');
    super.dispose();
  }

  _loadBooks() async {
    cachedResult = await _db.get('cached_detail');
    bookHistory = await _db.get('book_history');
    bookFavored = await _db.get('book_favored');
    setState((){});
  }

  _getBookInfo(bookId) {
    if (cachedResult != null && cachedResult[bookId] != null) {
      return cachedResult[bookId];
    } else return null;
  }

  RefreshIndicator bookPreview(context, orientation, Map bookList, String tabType) {
    return new RefreshIndicator(
      child: new ListView(
        children: <Widget>[
          bookList != null ? new Container(
            margin: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: _bookItems(context, orientation, bookList['doujinshi'], tabType, 'doujinshi'),
                ),
              ],
            ),
          ) : new Container(),
        ],
      ),
      onRefresh: _refreshHandle,
    );
  }

  Widget _bookItems(BuildContext context, Orientation orientation, bookList, String tabType, String bookType) {
    final double bookWidth = (orientation == Orientation.portrait) ? 165.0 : 190.0;
    final double bookHeight = bookWidth * 1.25;
    Map historyItems = {};
    if (tabType == 'history') {
      historyItems = bookList;
      bookList = bookList.keys.toList().reversed;
    } else bookList = bookList.reversed;
    return new Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: bookList.map((String bookId) {
        Map info = _getBookInfo(bookId);
        return info !=null ? new Container(
          width: bookWidth,
          height: bookHeight,
          child: new GridTile(
            child: new Material(
              color: Theme.of(context).cardColor,
              child: new GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(((bookType=='novel')?'/detail~novel/':'/detail~manga/') + JSON.encode(info['entry'])),
                child: new TransitionToImage(
                  new AdvancedNetworkImage(info['coverurl'], header: info['coverurl_header'], useDiskCache: true),
                ),
              ),
            ),
            footer: new GestureDetector(
              child: new GridTileBar(
                backgroundColor: Theme.of(context).cardColor.withOpacity(0.8),
                title: new Text(info['title'], style: new TextStyle(color: invertColor(Theme.of(context).cardColor), fontSize: 15.0)),
                subtitle: new Text((tabType != 'history') ? info['status'] : '看到'+historyItems[bookId]['chapter_title'], style: new TextStyle(color: invertColor(Theme.of(context).cardColor.withOpacity(0.8)), fontSize: 12.0)),
              ),
            ),
          ),
        ) : new Container();
      }).toList(),
    );
  }

  Future<Null> _refreshHandle() {
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(milliseconds: 200), () {
      completer.complete(_loadBooks());
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new TabBarView(
      children: <Widget>[
        bookPreview(context, orientation, bookFavored, 'favored'),
//        test(orientation),
//        test(orientation),
        bookPreview(context, orientation, bookHistory, 'history'),
      ],
    );
  }
}

TabBar tabbarDoujinshi() {
  return new TabBar(
    tabs: <Widget>[
      const Tab(text: '喜欢'),
//      const Tab(text: '本地'),
//      const Tab(text: '艺术家'),
      const Tab(text: '历史'),
    ],
  );
}

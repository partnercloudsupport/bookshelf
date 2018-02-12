import 'dart:async';
import 'dart:convert';

import 'package:bookshelf/database/db.dart';
import 'package:bookshelf/util/eventbus.dart';
import 'package:bookshelf/views/widgets/transition_to_image.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:bookshelf/util/util.dart';
import 'package:flutter/material.dart';

class WidgetBookshelf extends StatefulWidget {
  const WidgetBookshelf({ Key key }) : super(key: key);

  @override
  WidgetBookshelfState createState() => new WidgetBookshelfState();
}

class WidgetBookshelfState extends State<WidgetBookshelf> {
  Db _db = defaultDb;
  Map cachedResult;
  Map bookHistory;
  Map bookFavored;

  @override
  void initState() {
    super.initState();
    _loadBooks();
    bus.subscribe('reload_bookshelf', _refreshHandle);
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
                bookList['manga'].length != 0 ? new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
//                    new Divider(),
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 12.0),
                      child: new Text('漫画', style: new TextStyle(fontSize: 16.0, color: invertColor(Theme.of(context).cardColor.withOpacity(0.6)))),
                    ),
                  ],
                ) : new Column(),
                _bookItems(context, orientation, bookList['manga'], tabType, 'manga'),

                bookList['novel'].length != 0 ? new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Divider(),
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 12.0),
                      child: new Text('小说', style: new TextStyle(fontSize: 16.0, color: invertColor(Theme.of(context).cardColor.withOpacity(0.6)))),
                    ),
                  ],
                ) : new Column(),
                _bookItems(context, orientation, bookList['novel'], tabType, 'novel'),

                bookList['doujinshi'].length != 0 ? new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Divider(),
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 12.0),
                      child: new Text('同人志', style: new TextStyle(fontSize: 16.0, color: invertColor(Theme.of(context).cardColor.withOpacity(0.6)))),
                    ),
                  ],
                ) : new Column(),
                _bookItems(context, orientation, bookList['doujinshi'], tabType, 'doujinshi'),
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
        bookPreview(context, orientation, bookHistory, 'history'),
//        test(orientation),
      ],
    );
  }

}

GridView test(orientation) {
  return new GridView.count(
    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
    crossAxisCount: (orientation == Orientation.portrait) ? 3 : 5,
    childAspectRatio: (orientation == Orientation.portrait) ? 0.8 : 1.0,
    mainAxisSpacing: 10.0,
    crossAxisSpacing: 10.0,
    children: <Widget>[
      new Container(
        color: Colors.cyan,
      ),
      new Container(
        color: Colors.green,
      ),
      new Container(
        color: Colors.orange,
      ),
      new Container(
        color: Colors.greenAccent,
      ),
      new Container(
        color: Colors.amberAccent,
      ),
    ],
  );
}

TabBar tabbarBookshelf() {
  return new TabBar(
    tabs: <Widget>[
      const Tab(text: '喜欢'),
      const Tab(text: '历史'),
//      const Tab(text: '已下载'),
    ],
  );
}

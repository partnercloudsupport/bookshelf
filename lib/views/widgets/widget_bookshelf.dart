import 'dart:async';

import 'package:bookshelf/model/db.dart';
import 'package:bookshelf/util/image_provider.dart';
import 'package:flutter/material.dart';

TabBar tabbarBookshelf() {
  return new TabBar(
    tabs: <Widget>[
      const Tab(text: '喜欢'),
      const Tab(text: '历史'),
      const Tab(text: '已下载'),
    ],
  );
}

class WidgetBookshelf extends StatefulWidget {
  const WidgetBookshelf({ Key key }) : super(key: key);

  @override
  WidgetBookshelfState createState() => new WidgetBookshelfState();
}

class WidgetBookshelfState extends State<WidgetBookshelf> {
  DB _db = new DB();
  Map cachedResult;
  Map bookHistory;
  Map bookFavored;

  @override
  void initState() {
    super.initState();
    _db.init().then((_) => _loadBooks());
  }

  _loadBooks() async {
    cachedResult = await _db.get('cached_detail');
    bookHistory = await _db.get('book_history');
    bookFavored = await _db.get('book_favored');
    setState(() {});
  }

  _getBookinfo(bookId) {
    if (cachedResult != null && cachedResult[bookId] != null) {
      return cachedResult[bookId];
    } else return null;
  }

  RefreshIndicator bookPreview(context, orientation, Map bookList, String tabType) {
    return new RefreshIndicator(
      child: new ListView(
        children: <Widget>[
          bookList != null ? new Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                bookList['manga'].length != 0 ? new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Divider(),
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 12.0),
                      child: new Text('漫画', style: new TextStyle(fontSize: 16.0, color: Theme.of(context).accentColor.withOpacity(0.7))),
                    ),
                  ],
                ) : new Column(),
                _bookItems(context, orientation, bookList['manga']),
                bookList['novel'].length != 0 ? new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Divider(),
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 12.0),
                      child: new Text('小说', style: new TextStyle(fontSize: 16.0, color: Theme.of(context).accentColor.withOpacity(0.7))),
                    ),
                  ],
                ) : new Column(),
                _bookItems(context, orientation, bookList['novel']),
                bookList['doujinshi'].length != 0 ? new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Divider(),
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 12.0),
                      child: new Text('同人志', style: new TextStyle(fontSize: 16.0, color: Theme.of(context).accentColor.withOpacity(0.7))),
                    ),
                  ],
                ) : new Column(),
                _bookItems(context, orientation, bookList['doujinshi']),
              ],
            ),
          ) : new Container(),
        ],
      ),
      onRefresh: _refreshHandle,
    );
  }

  _bookItems(context, orientation, List bookList) {
    final double bookwidth = (orientation == Orientation.portrait) ? 165.0 : 190.0;
    final double bookheight = bookwidth * 1.25;
    return new Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: bookList.map((String bookId) {
        Map info = _getBookinfo(bookId);
        return info !=null ? new Container(
          width: bookwidth,
          height: bookheight,
          child: new GridTile(
            child: new Material(
              color: Theme.of(context).cardColor,
              child: new Image(
                image: new NetworkImageAdvance(info['coverurl'], header: info['coverurl_header']),
                fit: BoxFit.cover,
              ),
            ),
            footer: new GestureDetector(
              child: new GridTileBar(
                backgroundColor: Theme.of(context).cardColor.withOpacity(0.8),
                title: new Text(info['title'], style: new TextStyle(color: Theme.of(context).accentColor, fontSize: 14.0),),
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
      completer.complete();
    });
    return completer.future.then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new TabBarView(
        children: <Widget>[
          bookPreview(context, orientation, bookFavored, 'favored'),
          test(orientation),
          test(orientation),
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

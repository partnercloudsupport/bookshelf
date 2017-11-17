import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bookshelf/service/parse/parser.dart';
import 'package:bookshelf/util/image_provider.dart';
import 'package:bookshelf/util/constant.dart';

class ViewDetail extends StatefulWidget {
  const ViewDetail({
    Key key,
    this.bookInfo,
  }) : super(key: key);

  final Map bookInfo;

  @override
  ViewDetailState createState() => new ViewDetailState();
}

class ViewDetailState extends State<ViewDetail> {
  bool isFavourite = false;
  Parser parser = new Parser();
  Map bookDetail;

  Map chapterSelected;

  @override
  void initState() {
    super.initState();
    _getBookdetail();
  }

  _getBookdetail() async {
    var bookParser = parserSelector([widget.bookInfo['parser']])[0];
    Map result = await parser.getBookdetail(bookParser, widget.bookInfo['id']);
    setState(() {
      bookDetail = result;
    });
  }

  _selectChapter(chapter) {
    setState(() => chapterSelected = chapter);
    Map val = {
      'title': widget.bookInfo['title'],
      'parser': widget.bookInfo['parser'],
      'bid': widget.bookInfo['id'].toString(),
      'cid': chapter['chapter_id'].toString(),
    };
    switch (widget.bookInfo['type']) {
      case 'manga': Navigator.of(context).pushNamed('/viewer~manga/' + JSON.encode(val)); break;
      case 'novel': Navigator.of(context).pushNamed('/viewer~novel/' + JSON.encode(val)); break;
      case 'doujinshi': Navigator.of(context).pushNamed('/viewer~manga/' + JSON.encode(val)); break;
    }
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(milliseconds: 200), () {
      completer.complete(_getBookdetail());
    });
    return completer.future.then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text(widget.bookInfo['title']),
        actions: <Widget>[
          new IconButton(
            icon: isFavourite ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
            onPressed: () => setState(() => isFavourite = !isFavourite),
            tooltip: 'Add favourite',
          ),
          new IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {},
            tooltip: 'Download',
          ),
//          new IconButton(
//            icon: const Icon(Icons.refresh),
//            onPressed: () {_getBookdetail();},
//            tooltip: 'Refresh',
//          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
            height: 235.0,
            color: Theme.of(context).primaryColor,
            child: new Row(
              children: <Widget>[
                new Container(
                  height: 200.0,
                  width: 170.0,
                  margin: const EdgeInsets.only(right: 5.0),
                  child: bookDetail != null ? new Image(
                    image: new NetworkImageWithRetry(bookDetail['coverurl'], header: bookDetail['coverurl_header']),
                  ) : null,
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Container(
                        child: new Text(bookDetail != null ? bookDetail['title'] : '',
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      new Container(
                        padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 2.0),
                        child: new Row(
                          children: bookDetail != null ?
                          bookDetail['authors'].map((String author) {
                            return new Text(author + '  ',
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            );
                          }).toList() : <Widget>[],
                        ),
                      ),
                      new Container(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: new Row(
                          children: bookDetail != null ?
                          bookDetail['types'].map((String type) {
                            return new Text(type + '  ',
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            );
                          }).toList() : <Widget>[],
                        ),
                      ),
                      new Container(
                        child: new Text(bookDetail != null ? bookDetail['description'] : '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          new Material(
            elevation: 3.0,
            child: new Container(
              height: 30.0,
              color: Colors.grey.withOpacity(0.2),
              child: new Row(
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(left: 25.0),
                    child: new Text(widget.bookInfo != null ? getParserName(widget.bookInfo['parser']) : ''),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(left: 5.0),
                    child: new Text(bookDetail != null ? bookDetail['status'] : ''),
                  ),
                  new Expanded(
                    child: new Align(
                      alignment: Alignment.centerRight,
                      child: new Container(
                        margin: const EdgeInsets.only(right: 25.0),
                        child: new Text(bookDetail != null ? new DateFormat("yyyy-MM-dd").format(new DateTime.fromMillisecondsSinceEpoch(bookDetail['last_updatetime']*1000)) : ''),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Expanded(
            child: new RefreshIndicator(
                child: new GridView.count(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                  crossAxisCount: (orientation == Orientation.portrait) ? 5 : 8,
                  childAspectRatio: (orientation == Orientation.portrait) ? 2.5 : 2.5,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 12.0,
                  children: bookDetail !=null ?
                  bookDetail['chapters'].map((Map chapter) {
                    return new Material(
                        child: new ClipRRect(
                          borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
                          child: chapter == chapterSelected ? new FlatButton(
                            onPressed: () => _selectChapter(chapter),
                            child: new Text(chapter['chapter_title'], style: new TextStyle(
                              color: Theme.of(context).cardColor,
                            ), overflow: TextOverflow.ellipsis,),
                            color: Theme.of(context).primaryColor,
                            splashColor: Theme.of(context).primaryColor.withOpacity(0.8),
                          ) : new Container(
                            decoration: new BoxDecoration(
                              border: new Border.all(
                                color: Colors.black54.withOpacity(0.5),
                                width: 2.0,
                              ),
                              borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
                            ),
                            child: new InkWell(
                              borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
                              onTap: () => _selectChapter(chapter),
                              child: new Align(
                                alignment: Alignment.center,
                                child: new Text(chapter['chapter_title'], style: new TextStyle(
                                  color: Colors.black54.withOpacity(0.5),
                                ), overflow: TextOverflow.ellipsis,),
                              ),
                            ),
                          ),
                        )
                    );
                  }).toList() : <Widget>[],
                ),
                onRefresh: _handleRefresh,
            ),
          ),
        ],
      ),
    );
  }
}

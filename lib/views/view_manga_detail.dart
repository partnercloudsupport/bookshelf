import 'dart:async';
import 'dart:convert';

import 'package:bookshelf/database/db.dart';
import 'package:bookshelf/util/eventbus.dart';
import 'package:bookshelf/util/util.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:bookshelf/service/parser.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:bookshelf/util/constant.dart';

class ViewMangaDetail extends StatefulWidget {
  const ViewMangaDetail({
    Key key,
    this.bookInfo,
  }) : super(key: key);

  final Map bookInfo;

  @override
  ViewMangaDetailState createState() => new ViewMangaDetailState();
}

class ViewMangaDetailState extends State<ViewMangaDetail> {
  bool isFavourite = false;
  Parser parser = new Parser();
  Map bookDetail;
  Map chapterSelected;
  Db _db = defaultDb;
  String bookId;
  Map cachedResult;
  Map bookHistory;
  Map bookFavored;

  ScrollController _scrollController = new ScrollController();
  bool enableContinueReadingBtn = true;

  @override
  void initState() {
    super.initState();
    _getBookDetail();
  }

  _saveDetail(String cachedId, Map detail) {
    cachedResult[cachedId] = detail;
    _db.set('cached_detail', cachedResult).catchError((_){});
  }
  _saveHistory(String historyId, Map chapter) {
    bookHistory[widget.bookInfo['type']][historyId] = chapter;
    _db.set('book_history', bookHistory).catchError((_){});
  }
  _saveFavored() {
    _db.set('book_favored', bookFavored).catchError((_){});
  }
  _loadBookState () async {
    bookHistory = await _db.get('book_history');
    bookFavored = await _db.get('book_favored');
    if (bookHistory != null) {
      if (bookHistory.containsKey(widget.bookInfo['type']) && bookHistory[widget.bookInfo['type']].containsKey(bookId)) {
        setState(() => chapterSelected = bookHistory[widget.bookInfo['type']][bookId]);
      }
    } else bookHistory = {'manga': {}, 'novel': {}, 'doujinshi': {}};
    if (bookFavored != null) {
      if (bookFavored.containsKey(widget.bookInfo['type']) && bookFavored[widget.bookInfo['type']].contains(bookId)) {
        setState(() => isFavourite = true);
      }
    } else bookFavored = {'manga': [], 'novel': [], 'doujinshi': []};
  }

  _getBookDetail() async {
    bookId = md5.convert(UTF8.encode(widget.bookInfo['title'] + widget.bookInfo['id'] + widget.bookInfo['parser'])).toString().substring(0, 9);

    cachedResult = await _db.get('cached_detail');
    if (cachedResult != null) {
      if (cachedResult.containsKey(bookId)) setState(() => bookDetail = cachedResult[bookId]);
    } else cachedResult = {};
    await _loadBookState();

    var bookParser = parserSelector([widget.bookInfo['parser']])[widget.bookInfo['type']][0];
    parser.getBookDetail(bookParser, widget.bookInfo['id']).then((Map result) {
      result['entry'] = widget.bookInfo;
      if (cachedResult[bookId].toString() != result.toString()) {
        setState(() => bookDetail = result);
        if (chapterSelected != null || isFavourite) _saveDetail(bookId, result);
      } else print('no diff!');
    }).catchError((e) => print(e));
  }

  _selectChapter(chapter) {
    setState(() => chapterSelected = chapter);
    _saveDetail(bookId, bookDetail);
    _saveHistory(bookId, chapter);
    Map val = {
      'title': widget.bookInfo['title'],
      'parser': widget.bookInfo['parser'],
      'chapter_title': chapter['chapter_title'].toString(),
      'bid': widget.bookInfo['id'].toString(),
      'cid': chapter['chapter_id'].toString(),
      'type': widget.bookInfo['type']
    };
    bus.post('reload_bookshelf');
    switch (widget.bookInfo['type']) {
      case 'manga': Navigator.of(context).pushNamed('/viewer~manga/' + JSON.encode(val)); break;
      case 'doujinshi': Navigator.of(context).pushNamed('/viewer~manga/' + JSON.encode(val)); break;
    }
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(milliseconds: 200), () {
      completer.complete(_getBookDetail());
    });
    return completer.future.then((_) {});
  }

  friendlyDate(DateTime datetime) {
    int days = new DateTime.now().toLocal().difference(datetime).inDays;
    return days <= 100 ? '$days天前' : new DateFormat("yyyy-MM-dd").format(datetime);
  }

  toggleFavored() {
    setState(() => isFavourite = !isFavourite);
    if (isFavourite) {
      _saveDetail(bookId, bookDetail);
      if (!bookFavored[widget.bookInfo['type']].contains(bookId))
        bookFavored[widget.bookInfo['type']].add(bookId);
    } else bookFavored[widget.bookInfo['type']].remove(bookId);
    _saveFavored();
    bus.post('reload_bookshelf');
  }
  toggleDownloadMode() {}

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
            onPressed: toggleFavored,
            tooltip: '喜欢',
          ),
//          new IconButton(
//            icon: const Icon(Icons.file_download),
//            onPressed: toggleDownloadMode,
//            tooltip: '下载',
//          ),
        ],
      ),
      floatingActionButton: (chapterSelected != null && enableContinueReadingBtn == true) ? new FloatingActionButton(
        onPressed: () => _selectChapter(chapterSelected),
        child: const Icon(Icons.chrome_reader_mode),
      ): null,
      body: new Column(
        verticalDirection: VerticalDirection.up, // BUG: Column shadow casting
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0),
            height: 235.0,
            color: Theme.of(context).primaryColor,
            child: new Row(
              children: <Widget>[
                new GestureDetector(
                  onTap: () {},
                  child: new Container(
                    height: 200.0,
                    width: 160.0,
                    margin: const EdgeInsets.only(right: 15.0),
                    child: bookDetail != null ? new FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: new AssetImage('assets/loading.gif'),
                      image: new AdvancedNetworkImage(
                          bookDetail['coverurl'],
                          header: bookDetail['coverurl_header'],
                      ),
                    ) : null,
                  ),
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
                            height: 1.6
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
            elevation: 8.0,
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
                        child: new Text(bookDetail != null ? friendlyDate(new DateTime.fromMillisecondsSinceEpoch(bookDetail['last_updatetime']*1000)) : ''),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Expanded(
            child: new RefreshIndicator(
              child: new NotificationListener(
                onNotification: (_) {
                  if (bookDetail != null) {
                    double progress = _scrollController.offset / _scrollController.position.maxScrollExtent;
                    if (progress > 0.95 && enableContinueReadingBtn == true) setState(() => enableContinueReadingBtn = false);
                    else if (progress <= 0.95 && enableContinueReadingBtn == false) setState(() => enableContinueReadingBtn = true);
                  }
                },
                child: new GridView.count(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                  crossAxisCount: (orientation == Orientation.portrait) ? 5 : 8,
                  childAspectRatio: (orientation == Orientation.portrait) ? 2.5 : 2.5,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 12.0,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: bookDetail !=null ?
                  bookDetail['chapters'].map((Map chapter) {
                    return new Material(
                      child: new ClipRRect(
                        borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
                        child: chapter.toString() == chapterSelected.toString() ? new FlatButton(
                          onPressed: () => _selectChapter(chapter),
                          child: new Text(chapter['chapter_title'], style: new TextStyle(
                            color: Theme.of(context).cardColor,
                          ), overflow: TextOverflow.ellipsis),
                          color: invertColor(Theme.of(context).primaryColor),
                          splashColor: invertColor(Theme.of(context).primaryColor.withOpacity(0.8)),
                        ) : new Container(
                          decoration: new BoxDecoration(
                            border: new Border.all(
                              color: invertColor(Theme.of(context).cardColor.withOpacity(0.5)),
                              width: 1.5,
                            ),
                            borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
                          ),
                          child: new InkWell(
                            borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
                            onTap: () => _selectChapter(chapter),
                            child: new Padding(
                              padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                              child: new Align(
                                alignment: Alignment.center,
                                child: new Text(chapter['chapter_title'], style: new TextStyle(
                                  color: invertColor(Theme.of(context).cardColor.withOpacity(0.5)),
                                ), overflow: TextOverflow.ellipsis,),
                              ),
                            ),
                          ),
                        ),
                      )
                    );
                  }).toList() : <Widget>[],
                )
              ),
              onRefresh: _handleRefresh,
            ),
          )
        ].reversed.toList(),
      ),
    );
  }
}

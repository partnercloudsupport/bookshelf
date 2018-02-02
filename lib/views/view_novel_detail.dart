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

class ViewNovelDetail extends StatefulWidget {
  const ViewNovelDetail({
    Key key,
    this.bookInfo,
  }) : super(key: key);

  final Map bookInfo;

  @override
  ViewNovelDetailState createState() => new ViewNovelDetailState();
}

class ViewNovelDetailState extends State<ViewNovelDetail> {
  bool isFavourite = false;
  Parser parser = new Parser();
  Map bookDetail;
  Map chapterSelected;
  Db _db = defaultDb;
  String bookId;
  Map cachedResult;
  Map bookHistory;
  Map bookFavored;
  int readingProgress = 0;
  String readingVolumeTitle = '';

  ScrollController _scrollController = new ScrollController();
  bool enableContinueReadingBtn = true;

  @override
  void initState() {
    super.initState();
    _getBookDetail();
    bus.subscribe('set_reading_progress', (f) {
      readingProgress = f();
      _saveHistory(bookId, chapterSelected, readingVolumeTitle, readingProgress);
    });
  }

  _saveDetail(String cachedId, Map detail) {
    cachedResult[cachedId] = detail;
    _db.set('cached_detail', cachedResult).catchError((_){});
  }
  _saveHistory(String historyId, Map chapter, String volumeTitle, int progress) {
    bookHistory[widget.bookInfo['type']][historyId] = {
      'chapter': chapter,
      'volume': volumeTitle,
      'progress': progress,
      'chapter_title': chapter['chapter_title']
    };
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
        setState(() {
          chapterSelected = bookHistory[widget.bookInfo['type']][bookId]['chapter'];
          readingProgress = bookHistory[widget.bookInfo['type']][bookId]['progress'];
          readingVolumeTitle = bookHistory[widget.bookInfo['type']][bookId]['volume'];
        });
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

    var bookParser = parserSelector([widget.bookInfo['parser']])['novel'][0];
    parser.getBookDetail(bookParser, widget.bookInfo['id']).then((Map result) {
      result['entry'] = widget.bookInfo;
      if (cachedResult[bookId].toString() != result.toString()) {
        setState(() => bookDetail = result);
        if (chapterSelected != null || isFavourite) _saveDetail(bookId, result);
      } else print('no diff!');
    }).catchError((e) => print(e));
  }

  _selectChapter(Map chapter, String volumeTitle) {
    if (chapterSelected != chapter) readingProgress = 0;
    setState(() {
      chapterSelected = chapter;
      readingVolumeTitle = volumeTitle;
    });
    _saveDetail(bookId, bookDetail);
    _saveHistory(bookId, chapter, volumeTitle, readingProgress);
    Map val = {
      'title': widget.bookInfo['title'],
      'parser': widget.bookInfo['parser'],
      'chapter_title': chapter['chapter_title'].toString(),
      'volume_title': volumeTitle,
      'bid': widget.bookInfo['id'].toString(),
      'vid': chapter['volume_id'].toString(),
      'cid': chapter['chapter_id'].toString(),
      'progress': readingProgress,
    };
    bus.post('reload_bookshelf');
    Navigator.of(context).pushNamed('/viewer~novel/' + JSON.encode(val));
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(milliseconds: 200), () {
      completer.complete(_getBookDetail());
    });
    return completer.future.then((_) {});
  }

  String friendlyDate(DateTime datetime) {
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
    bus.post('reload_bookshelf');
    _saveFavored();
  }
  toggleDownloadMode() async {}

  // TODO: rewrite the chapter style to popup dialog

  @override
  Widget build(BuildContext context) {
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
          new IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: toggleDownloadMode,
            tooltip: '下载',
          ),
        ],
      ),
      floatingActionButton: (chapterSelected != null && enableContinueReadingBtn) ? new FloatingActionButton(
        onPressed: () => _selectChapter(chapterSelected, readingVolumeTitle),
        child: const Icon(Icons.chrome_reader_mode),
      ): null,
      body: new RefreshIndicator(
        child: new NotificationListener(
          onNotification: (_) {
            if (bookDetail != null) {
              double progress = _scrollController.offset / _scrollController.position.maxScrollExtent;
              if (progress > 0.98 && enableContinueReadingBtn == true) setState(() => enableContinueReadingBtn = false);
              else if (progress <= 0.98 && enableContinueReadingBtn == false) setState(() => enableContinueReadingBtn = true);
            }
          },
          child: new ListView(
            controller: _scrollController,
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
                        width: 170.0,
                        margin: const EdgeInsets.only(right: 15.0),
                        child: bookDetail != null ? new Image(
                          image: new AdvancedNetworkImage(
                            bookDetail['coverurl'],
                            header: bookDetail['coverurl_header'],
                          ),
                          fit: BoxFit.cover,
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
              new Container(
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
              new Column(
                children: bookDetail != null ?
                bookDetail['chapters'].map((Map volume) {
                  return new Column(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: new Material(
                          elevation: 8.0,
                          child: new Container(
                            color: Theme.of(context).primaryColor,
                            height: 80.0,
                            child: new Align(
                              alignment: Alignment.bottomLeft,
                              child: new Padding(
                                padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 10.0),
                                child: new Text(volume['volume_title'], style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0, fontWeight: FontWeight.bold
                                )),
                              ),
                            ),
                          ),
                        ),
                      ),
                      new Column(
                        children: volume['chapters'].map((Map chapter) {
                          return new InkWell(
                            onTap: () {_selectChapter(chapter, volume['volume_title']);},
                            child: new Container(
                              height: 40.0,
                              padding: const EdgeInsets.only(left: 40.0),
                              child: new Align(
                                alignment: Alignment.centerLeft,
                                child: new Text(chapter['chapter_title']),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  );
                }).toList() : <Widget>[],
              )
            ],
          )
        ),
        onRefresh: _handleRefresh,
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:battery/battery.dart';
import 'package:bookshelf/service/parse/parser.dart';
import 'package:bookshelf/util/image_provider.dart';
import 'package:intl/intl.dart';

class MangaViewer extends StatefulWidget {
  const MangaViewer({
    Key key,
    this.chapterInfo,
  }) : super(key: key);

  final Map chapterInfo;

  @override
  MangaViewerState createState() => new MangaViewerState();
}

class MangaViewerState extends State<MangaViewer> {
  Parser parser = new Parser();

  Map content;
  bool isShowinformation = false;

  Battery _battery = new Battery();
  BatteryState batteryState;
  StreamSubscription<BatteryState> _batteryStateSubscription;
  int batteryLevel;
  Timer repeater;
  DateTime now;
  double scaleSize = 1.0;
  ScrollController _scrollController = new ScrollController();
  int currentPage = 1;
  bool atBottom = false;

  @override
  void initState() {
    super.initState();
    _getChaptercontent();
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() => batteryState = state);
    });
    _battery.batteryLevel.then((int val) => setState(() => batteryLevel = val));
    setState(() => now = new DateTime.now().toLocal());
    repeater = new Timer.periodic(new Duration(seconds: 23), (timer) {
      _battery.batteryLevel.then((int val) => setState(() => batteryLevel = val));
      setState(() => now = new DateTime.now().toLocal());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _showInformation();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription.cancel();
    }
    repeater.cancel();
  }

  _getChaptercontent() async {
    var bookParser = parserSelector([widget.chapterInfo['parser']])[0];
    Map result = await parser.getChapterContent(bookParser, widget.chapterInfo['bid'], widget.chapterInfo['cid']);
    setState(() => content = result);
    _hideInformation();
  }

  _hideInformation() {
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
  _showInformation() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  Future<Null> _loadPreviewChapter() {
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(milliseconds: 200), () {
      completer.complete();
    });
    return completer.future.then((_) {});
  }
  Future<Null> _loadNextChapter() {
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(milliseconds: 200), () {
      completer.complete();
      print('t');
    });
    return completer.future.then((_) {});
  }

  batteryLevelIcon() {
    IconData batteryIcon = Icons.battery_unknown;
    if (batteryState == BatteryState.discharging) {
      if (batteryLevel <= 25) {
        batteryIcon = Icons.battery_alert;
      } else {
        batteryIcon = Icons.battery_std;
      }
    } else if (batteryState == BatteryState.charging) {
      batteryIcon = Icons.battery_charging_full;
    } else {
      batteryIcon = Icons.battery_full;
    }
    return batteryIcon;
  }

  scrollTo(double offset) {
    _scrollController.animateTo(offset, duration: new Duration(seconds: 1), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new CustomMultiChildLayout(
      delegate: new _MangaviewerLayout(),
      children: <Widget>[
        new LayoutId(
            id: _MangaviewerLayout.viewer,
            child: new RefreshIndicator(
                onRefresh: _loadPreviewChapter,
                child: new GestureDetector(
                  onDoubleTap: () {},
                  child: new Container(
                      color: Colors.black,
//                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
//                      transform: new Matrix4.diagonal3(new Vector3(3.0, 3.0, 3.0)),
                      child: new Transform(
                        transform: new Matrix4.identity()..scale(scaleSize, scaleSize),
                        alignment: Alignment.center,
                        child: new NotificationListener(
                          onNotification: (_) {
                            if (content != null) {
                              double maxRange = _scrollController.position.maxScrollExtent;
                              int page = (_scrollController.offset / maxRange * content['picture_urls'].length).ceil();
                              setState(() => currentPage = (page == 0 ? 1 : page));
                              if (currentPage == content['picture_urls'].length) {
                                if (atBottom == false) {
                                  setState(() => atBottom = true);
                                  _loadNextChapter();
                                }
                              } else {
                                if (atBottom == true) setState(() => atBottom = false);
                              }
                            }
                          },
                          child: new ListView.builder(
//                          scrollDirection: Axis.horizontal,
                            controller: _scrollController,
                            itemCount: content != null ? content['picture_urls'].length : 0,
                            itemBuilder: (BuildContext context, int index) {
//                            print(index);
                              return content != null ? new Image(
                                image: new AdvancedNetworkImage(content['picture_urls'][index], header: content['picture_header']),
                              ) : new Container();
                            },
                          ),
                        ),
                      )
                  ),
                )
            ),
        ),
        new LayoutId(
          id: _MangaviewerLayout.statusbartop,
          child: new Material(
            color: Colors.black.withOpacity(0.3),
            child: new Row(
              children: <Widget>[
                new Container(
                  width: (orientation == Orientation.portrait) ? 235.0 : 395.0,
                  margin: const EdgeInsets.only(left: 10.0),
                  child: new Text(widget.chapterInfo != null ? widget.chapterInfo['title'] : '',
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ),
                new Container(
                  width: 130.0,
                  margin: const EdgeInsets.only(left: 8.0),
                  child: new Text(widget.chapterInfo != null ? widget.chapterInfo['chapter_title'] : '',
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ),
                new Expanded(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(right: 15.0),
                        child: new Text(now != null ? new DateFormat("HH:mm").format(now) : '',
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                      new Container(
                        margin: const EdgeInsets.only(right: 5.0),
                        child: new Transform.rotate(
                          angle: 4.7,
                          child: new Icon(batteryLevelIcon(), size: 18.0, color: Colors.white,),
                        ),
                      ),
                      new Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        child: new Text('$batteryLevel %',
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        new LayoutId(
          id: _MangaviewerLayout.statusbarbottom,
          child: new Material(
            color: Colors.black.withOpacity(0.3),
            child: new Container(
              alignment: Alignment.center,
              child: new Text(content != null ? '$currentPage/'+content['picture_urls'].length.toString() : '',
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(color: Colors.white, fontSize: 12.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MangaviewerLayout extends MultiChildLayoutDelegate {
  _MangaviewerLayout();

  static final String statusbartop = 'statusbartop';
  static final String statusbarbottom = 'statusbarbottom';
  static final String viewer = 'viewer';
  static final double statusbarheight = 18.0;

  @override
  void performLayout(Size size) {
    layoutChild(viewer, new BoxConstraints.tightFor(width: size.width, height: size.height));
    positionChild(viewer, Offset.zero);
    layoutChild(statusbartop, new BoxConstraints.tightFor(width: size.width, height: statusbarheight));
    positionChild(statusbartop, Offset.zero);
    layoutChild(statusbarbottom, new BoxConstraints.tightFor(width: size.width, height: statusbarheight));
    positionChild(statusbarbottom, new Offset(0.0, size.height - statusbarheight));
  }

  @override
  bool shouldRelayout(_MangaviewerLayout oldDelegate) => false;
}

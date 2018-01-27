import 'dart:async';

import 'package:battery/battery.dart';
import 'package:bookshelf/service/parse/parser.dart';
import 'package:bookshelf/util/eventbus.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NovelViewer extends StatefulWidget {
  const NovelViewer({
    Key key,
    this.chapterInfo,
  }) : super(key: key);

  final Map chapterInfo;

  @override
  NovelViewerState createState() => new NovelViewerState();
}

class NovelViewerState extends State<NovelViewer> {
  Parser parser = new Parser();

  List content;
  bool isShowInformation = false;

  Battery _battery = new Battery();
  BatteryState batteryState;
  StreamSubscription<BatteryState> _batteryStateSubscription;
  int batteryLevel;
  Timer repeater;
  DateTime now;
  ScrollController _scrollController = new ScrollController();
  double fontSize = 16.0;
  int readingProgress = 0;

  @override
  void initState() {
    super.initState();
    _hideInformation();
    _getChapterContent();
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() => batteryState = state);
    });
    _battery.batteryLevel.then((int val) => setState(() => batteryLevel = val));
    setState(() => now = new DateTime.now().toLocal());
    repeater = new Timer.periodic(new Duration(seconds: 23), (timer) {
      _battery.batteryLevel.then((int val) => setState(() => batteryLevel = val));
      setState(() => now = new DateTime.now().toLocal());
    });
    setState(() => readingProgress = widget.chapterInfo['progress']);
    new Timer(new Duration(seconds: 3), () => scrollTo(_scrollController.position.maxScrollExtent*readingProgress/100));
  }
  @override
  void dispose() {
    super.dispose();
    _showInformation();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription.cancel();
    }
    repeater.cancel();
    bus.post('set_reading_progress', () => readingProgress);
  }

  _getChapterContent() async {
    var bookParser = parserSelector([widget.chapterInfo['parser']])['novel'][0];
    List result = await parser.getChapterContent(bookParser, widget.chapterInfo['bid'], widget.chapterInfo['cid'], widget.chapterInfo['vid']);
    setState(() => content = result);
    _hideInformation();
  }

  _hideInformation() => SystemChrome.setEnabledSystemUIOverlays([]);
  _showInformation() => SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

  scrollTo(double offset) {
    _scrollController.animateTo(offset, duration: new Duration(seconds: 1), curve: Curves.ease);
  }

  batteryLevelIcon() {
    IconData batteryIcon = Icons.battery_unknown;
    if (batteryState == BatteryState.discharging) {
      if (batteryLevel <= 25) batteryIcon = Icons.battery_alert;
      else batteryIcon = Icons.battery_std;
    }
    else if (batteryState == BatteryState.charging) batteryIcon = Icons.battery_charging_full;
    else batteryIcon = Icons.battery_full;

    return batteryIcon;
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
      print('at bottom');
    });
    return completer.future.then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new CustomMultiChildLayout(
      delegate: new _NovelViewerLayout(),
      children: <Widget>[
        new LayoutId(
          id: _NovelViewerLayout.background,
          child: new Container(color: Theme.of(context).cardColor)
        ),
        new LayoutId(
          id: _NovelViewerLayout.viewer,
          child: new Column(
            children: <Widget>[
              new Material(
                color: Colors.black.withOpacity(0.5),
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
                      child: new Text(widget.chapterInfo != null ? '$readingProgress %' : '',
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
                              child: new Icon(batteryLevelIcon(), size: 18.0, color: Colors.white),
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
              new Expanded(
                child: new NotificationListener(
                  onNotification: (_) {
                    if (content != null) {
                      double maxRange = _scrollController.position.maxScrollExtent;
                      int progress = ((_scrollController.offset / maxRange) * 100).ceil();
                      setState(() => readingProgress = (progress == 0 ? 1 : progress));
                    }
                  },
                  child: new RefreshIndicator(
                    child: new SingleChildScrollView(
//                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      child: new ConstrainedBox(
                        constraints: (orientation == Orientation.portrait) ? const BoxConstraints(minHeight: 850.0) : const BoxConstraints(minHeight: 550.0),
                        child: new Material(
                          color: Colors.black.withOpacity(0.3),
                          child: new Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: content != null ?
                              new ListBody(
                                children: content.map((Map cont) {
                                  if (cont.containsKey('img')) return new Image(image: new AdvancedNetworkImage(cont['img']['url'], header: cont['img']['header']));
                                  else return new Text(cont['text'], style: new TextStyle(fontSize: fontSize, height: 1.8));
                                }).toList(),
                              )
                              : new Container(),
                          )
                        ),
                      ),
                    ),
                    onRefresh: _loadPreviewChapter
                  )
                ),
              ),
              new Material(
                color: Colors.black.withOpacity(0.5),
                child: new Row(
                  children: <Widget>[
                    new Container(
                      width: 200.0,
                      padding: const EdgeInsets.only(left: 10.0),
                      child: new Text(content != null ? widget.chapterInfo['volume_title'] : '',
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(color: Colors.white, fontSize: 12.0),
                      ),
                    ),
                    new Expanded(
                        child: new Align(
                          alignment: Alignment.centerRight,
                          child: new Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: new Text(content != null ? widget.chapterInfo['chapter_title'] : '',
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(color: Colors.white, fontSize: 12.0),
                            ),
                          ),
                        )
                    )
                  ],
                ),
              ),
            ],
          )
        )
      ],
    );
  }
}

class _NovelViewerLayout extends MultiChildLayoutDelegate {
  _NovelViewerLayout();

  static final String background = 'background';
  static final String viewer = 'viewer';

  @override
  void performLayout(Size size) {
    layoutChild(viewer, new BoxConstraints.tightFor(width: size.width, height: size.height));
    positionChild(viewer, Offset.zero);
    layoutChild(background, new BoxConstraints.tightFor(width: size.width, height: size.height));
    positionChild(background, Offset.zero);
  }

  @override
  bool shouldRelayout(_NovelViewerLayout oldDelegate) => false;
}

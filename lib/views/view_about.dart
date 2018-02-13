import 'dart:async';

import 'package:bookshelf/views/widgets/_transition_to_image.dart';
import 'package:flutter/material.dart';
import 'package:bookshelf/util/constant.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';

class ViewAbout extends StatelessWidget {
  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(milliseconds: 200), () {
      completer.complete();
    });
    return completer.future.then((_) {});
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text('关于'),
      elevation: 0.0,
    ),
    body: new RefreshIndicator(
//      child: new Column(
//        children: <Widget>[
//          new SizedBox(
//            height: 500.0,
//            child: new Container(
//              child: new TransitionToImage(
//                  new AdvancedNetworkImage('https://user-images.githubusercontent.com/1551736/28209258-53234bf0-68c4-11e7-9586-d4a3526f0f45.png'),
//              ),
//            ),
//          ),
//          new Expanded(
//              child: new Container(
//                color: Colors.green,
//              )
//          )
//        ],
//      ),
        child: new ListView(
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.fromLTRB(0.0, 64.0, 0.0, 64.0),
              decoration: new BoxDecoration(color: Colors.blue),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    appname,
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 52.0,
                    ),
                  ),
                  new Text(
                    'Version: $version',
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        onRefresh: _handleRefresh,
    )
  );
}

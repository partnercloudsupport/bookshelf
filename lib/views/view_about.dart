import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bookshelf/util/constant.dart';

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

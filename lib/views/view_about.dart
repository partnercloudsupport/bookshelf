import 'package:flutter/material.dart';
import 'package:bookshelf/util/constant.dart';

class ViewAbout extends StatelessWidget {

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text('关于'),
      elevation: 0.0,
    ),
    body: new ListView(
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
                'version: ' + version,
                style: new TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        new ListTile(
          title: const Text('Check update'),
          subtitle: const Text('test'),
          onTap: () {},
        )
      ],
    ),
  );
}

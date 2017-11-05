import 'package:flutter/material.dart';

class ViewSettings extends StatelessWidget {

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text('Settings'),
    ),
    body: new PageView(
      children: <Widget>[
        new Column(
          children: <Widget>[
            new Text('test')
          ],
        )
      ],
    ),
  );
}

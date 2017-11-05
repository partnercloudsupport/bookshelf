import 'package:flutter/material.dart';

class WidgetNovel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'This is novel!',
          )
        ],
      ),
    );
  }
}

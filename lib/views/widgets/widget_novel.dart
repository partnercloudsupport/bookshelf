import 'package:flutter/material.dart';

TabBar tabbarNovel() {
  return new TabBar(
    tabs: <Widget>[
      new Tab(text: 'Recommend'),
      new Tab(text: 'Favorite'),
      new Tab(text: 'Local'),
      new Tab(text: 'History'),
    ],
  );
}

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

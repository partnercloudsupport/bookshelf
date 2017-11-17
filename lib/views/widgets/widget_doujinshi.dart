import 'package:flutter/material.dart';

TabBar tabbarDoujinshi() {
  return new TabBar(
    tabs: <Widget>[
      new Tab(text: 'Recommend'),
      new Tab(text: 'Favorite'),
      new Tab(text: 'Local'),
      new Tab(text: 'History'),
    ],
  );
}

class WidgetDoujinshi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'This is doujinshi!',
          )
        ],
      ),
    );
  }
}

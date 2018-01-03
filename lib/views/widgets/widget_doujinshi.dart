import 'package:flutter/material.dart';

TabBar tabbarDoujinshi() {
  return new TabBar(
    tabs: <Widget>[
      const Tab(text: '喜欢'),
      const Tab(text: '本地'),
      const Tab(text: '艺术家'),
      const Tab(text: '历史'),
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

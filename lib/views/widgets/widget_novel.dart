import 'package:flutter/material.dart';

TabBar tabbarNovel() {
  return new TabBar(
    tabs: <Widget>[
      const Tab(text: '喜欢'),
      const Tab(text: '本地'),
      const Tab(text: '推荐'),
      const Tab(text: '历史'),
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

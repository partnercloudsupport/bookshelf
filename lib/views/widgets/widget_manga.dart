import 'package:flutter/material.dart';

class WidgetManga extends StatefulWidget {
  const WidgetManga({ Key key }) : super(key: key);

  @override
  WidgetMangaState createState() => new WidgetMangaState();
}

class WidgetMangaState extends State<WidgetManga> {

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new TabBarView(
      children: <Widget>[
        test(orientation),
        test(orientation),
        test(orientation),
        test(orientation),
      ],
    );
  }
}

GridView test(orientation) {
  return new GridView.count(
    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
    crossAxisCount: (orientation == Orientation.portrait) ? 3 : 5,
    childAspectRatio: (orientation == Orientation.portrait) ? 0.8 : 1.0,
    mainAxisSpacing: 10.0,
    crossAxisSpacing: 10.0,
    children: <Widget>[
      new Container(
        color: Colors.orange,
      ),
      new Container(
        color: Colors.greenAccent,
      ),
      new Container(
        color: Colors.cyan,
      ),
      new Container(
        color: Colors.amberAccent,
      ),
      new Container(
        color: Colors.green,
      ),
    ],
  );
}

TabBar tabbarManga() {
  return new TabBar(
    tabs: <Widget>[
      const Tab(text: '喜欢'),
//      const Tab(text: '本地'),
//      const Tab(text: '推荐'),
      const Tab(text: '历史'),
    ],
  );
}
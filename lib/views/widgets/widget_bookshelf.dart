import 'package:flutter/material.dart';

TabBar tabbarBookshelf() {
  return new TabBar(
    tabs: <Widget>[
      new Tab(text: 'Recommend'),
      new Tab(text: 'History'),
      new Tab(text: 'Favorite'),
      new Tab(text: 'Downloaded'),
      new Tab(text: 'Local'),
    ],
  );
}

class WidgetBookshelf extends StatefulWidget {
  const WidgetBookshelf({ Key key }) : super(key: key);

  @override
  WidgetBookshelfState createState() => new WidgetBookshelfState();
}

class WidgetBookshelfState extends State<WidgetBookshelf> {

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new TabBarView(
        children: <Widget>[
          new GridView.count(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            crossAxisCount: (orientation == Orientation.portrait) ? 3 : 5,
            childAspectRatio: (orientation == Orientation.portrait) ? 0.8 : 1.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            children: <Widget>[
              new Container(
                color: Colors.cyan,
              ),
              new Container(
                color: Colors.green,
              ),
              new Container(
                color: Colors.orange,
              ),
              new Container(
                color: Colors.greenAccent,
              ),
              new Container(
                color: Colors.amberAccent,
              ),
            ],
          ),
        ],
    );
  }
}

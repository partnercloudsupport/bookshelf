import 'package:flutter/material.dart';

class NovelViewer extends StatefulWidget {
  const NovelViewer({
    Key key,
    this.chapterInfo,
  }) : super(key: key);

  final Map chapterInfo;


  @override
  NovelViewerState createState() => new NovelViewerState();
}

class NovelViewerState extends State<NovelViewer> {

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[],
    );
  }
}

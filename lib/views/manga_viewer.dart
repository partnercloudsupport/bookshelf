import 'package:flutter/material.dart';
import 'package:bookshelf/service/parse/parser.dart';
import 'package:bookshelf/util/image_provider.dart';

class MangaViewer extends StatefulWidget {
  const MangaViewer({
    Key key,
    this.chapterInfo,
  }) : super(key: key);

  final Map chapterInfo;

  @override
  MangaViewerState createState() => new MangaViewerState();
}

class MangaViewerState extends State<MangaViewer> {
  Parser parser = new Parser();

  Map content;

  @override
  void initState() {
    super.initState();
    _getChaptercontent();
  }

  _getChaptercontent() async {
    var bookParser = parserSelector([widget.chapterInfo['parser']])[0];
    Map result = await parser.getChaptercontent(bookParser, widget.chapterInfo['bid'], widget.chapterInfo['cid']);
    setState(() => content = result);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new GestureDetector(
        child: new Container(
//          transform: new Matrix4.diagonal3(new Vector3(3.0, 3.0, 3.0)),
          child: new ListView(
            children: content != null ? content['picture_urls'].map((String pageUrl) {
              return new Container(
                child: new Image(
                  image: new NetworkImageWithRetry(pageUrl, header: content['picture_header']),
                ),
              );
            }).toList() : <Widget>[],
          ),
        ),
      ),
    );
  }
}

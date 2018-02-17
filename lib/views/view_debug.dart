import 'package:bookshelf/util/_old_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_networkimage/transition_to_image.dart';

class ViewDebug extends StatefulWidget {
  @override
  _ViewDebugState createState() => new _ViewDebugState();

}

class _ViewDebugState extends State<ViewDebug> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new SizedBox(
          height: 500.0,
          child: new Container(
            child: new TransitionToImage(
              new AdvancedNetworkImage('https://i.nhentai.net/galleries/1175501/3.jpg'),
            ),
          ),
        ),
        new Expanded(
            child: new Container(
              color: Colors.green,
            )
        )
      ],
    );
  }

}
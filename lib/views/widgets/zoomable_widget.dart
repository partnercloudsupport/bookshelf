import 'package:flutter/material.dart';

class ZoomableWidget extends StatelessWidget {
  ZoomableWidget({
    Key key,
    this.minScale: 0.7,
    this.maxScale: 1.4,
    Widget child,
  }) : assert(minScale != null),
       assert(maxScale != null);

  final double maxScale;
  final double minScale;

  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}

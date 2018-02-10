import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class _ZoomableWidgetLayout extends MultiChildLayoutDelegate {
  _ZoomableWidgetLayout();

  static final String gestureContainer = 'gesturecontainer';
  static final String painter = 'painter';

  @override
  void performLayout(Size size) {
    layoutChild(gestureContainer, new BoxConstraints.tightFor(width: size.width, height: size.height));
    positionChild(gestureContainer, Offset.zero);
    layoutChild(painter, new BoxConstraints.tightFor(width: size.width, height: size.height));
    positionChild(painter, Offset.zero);
  }

  @override
  bool shouldRelayout(_ZoomableWidgetLayout oldDelegate) => false;
}

class ZoomableWidget extends StatefulWidget {
  const ZoomableWidget({
    Key key,
    this.minScale: 0.7,
    this.maxScale: 1.4,
    this.enableZoom: true,
    this.enablePan: true,
    this.child,
  })
      : assert(minScale != null),
        assert(maxScale != null),
        assert(enableZoom != null),
        assert(enablePan != null);

  final double maxScale;
  final double minScale;
  final bool enableZoom;
  final bool enablePan;
  final Widget child;

  @override
  _ZoomableWidgetState createState() => new _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget> with TickerProviderStateMixin {
  double _zoom = 1.0;
  double _previewZoom = 1.0;
  Offset _previewPanOffset = Offset.zero;
  Offset _panOffset = Offset.zero;
  Offset _zoomOriginOffset = Offset.zero;

  AnimationController _controller;
  Animation<double> _zoomAnimation;

  @override
  initState() {
    _controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _zoomAnimation = new Tween(begin: 1.0, end: _zoom).animate(_controller);
    _controller.forward();
    super.initState();
  }
  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onScaleStart(ScaleStartDetails details) => setState(() {
    _zoomOriginOffset = details.focalPoint;
    _previewPanOffset = _panOffset;
    _previewZoom = _zoom;
  });
  _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.scale != 1.0) {
      setState(() {
        _zoom = (_previewZoom * details.scale).clamp(widget.minScale, widget.maxScale);
        _panOffset = details.focalPoint - (_zoomOriginOffset - _previewPanOffset) / _previewZoom * _zoom;
      });
    }
  }
  _handleReset() {
    setState(() {
      _zoom = 1.0;
      _previewZoom = 1.0;
      _zoomOriginOffset = Offset.zero;
      _previewPanOffset = Offset.zero;
      _panOffset = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) return new Container();
    return new CustomMultiChildLayout(
      delegate: new _ZoomableWidgetLayout(),
      children: <Widget>[
        new LayoutId(
          id: _ZoomableWidgetLayout.painter,
          child: new _AnimatedWidget(animation: _zoomAnimation ,zoom: _zoom, panOffset: _panOffset, child: widget.child),
        ),
        new LayoutId(
            id: _ZoomableWidgetLayout.gestureContainer,
            child: new GestureDetector(
              child: new Container(color: new Color(0)),
              onScaleStart: widget.enableZoom ? _onScaleStart : null,
              onScaleUpdate: widget.enableZoom ? _onScaleUpdate : null,
              onDoubleTap: _handleReset,
            )
        ),
      ]
    );
  }
}

class _AnimatedWidget extends AnimatedWidget {
  _AnimatedWidget({
    Key key,
    Animation<double> animation,
    @required this.zoom,
    @required this.panOffset,
    @required this.child
  }) : super(key: key, listenable: animation);

  final double zoom;
  final Offset panOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Transform(
      transform: new Matrix4.identity()
        ..scale(animation.value, animation.value),
      child: new Transform(
        transform: new Matrix4.identity()
          ..translate(panOffset.dx, panOffset.dy),
        child: child,
      ),
    );
  }

}









//class ZoomableWidgets extends StatefulWidget {
//  const ZoomableWidgets({
//    Key key,
//    this.minScale: 0.7,
//    this.maxScale: 1.4,
//    this.enableZoom: true,
//    this.enablePan: true,
//    this.child,
//  })
//      : assert(minScale != null),
//        assert(maxScale != null),
//        assert(enableZoom != null),
//        assert(enablePan != null);
//
//  final double maxScale;
//  final double minScale;
//  final bool enableZoom;
//  final bool enablePan;
//  final Widget child;
//
//  @override
//  ZoomableWidgetsState createState() => new ZoomableWidgetsState();
//}

//class ZoomableWidgetsState extends State<ZoomableWidgets> {
//  double zoom = 1.0;
//  double previewZoom = 1.0;
//  Offset previewPanOffset = Offset.zero;
//  Offset panOffset = Offset.zero;
//  Offset zoomOriginOffset = Offset.zero;
//
//  _onScaleStart(ScaleStartDetails details) => setState(() {
//    zoomOriginOffset = details.focalPoint;
//    previewPanOffset = panOffset;
//    previewZoom = zoom;
//  });
//  _onScaleUpdate(ScaleUpdateDetails details) {
//    if (details.scale != 1.0) {
//      setState(() {
//        zoom = (previewZoom * details.scale)
//            .clamp(widget.minScale, widget.maxScale);
//        panOffset = details.focalPoint - (zoomOriginOffset - previewPanOffset) / previewZoom * zoom;
//      });
//    }
//  }
//  _handleReset() {
//    setState(() {
//      zoom = 1.0;
//      previewZoom = 1.0;
//      zoomOriginOffset = Offset.zero;
//      previewPanOffset = Offset.zero;
//      panOffset = Offset.zero;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (widget.child == null) return new Container();
//    return new GestureDetector(
//      child: _child(widget.child),
//      onScaleStart: widget.enableZoom ? _onScaleStart : null,
//      onScaleUpdate: widget.enableZoom ? _onScaleUpdate : null,
//      onDoubleTap: _handleReset,
//    );
//  }
//
//  Widget _child(Widget child) {
//    return new Transform(
//      transform: new Matrix4.identity()
//        ..scale(zoom, zoom),
//      child: new Transform(
//        transform: new Matrix4.translationValues(
//            panOffset.dx, panOffset.dy, 0.0),
//        child: child,
//      ),
//    );
//  }
//}

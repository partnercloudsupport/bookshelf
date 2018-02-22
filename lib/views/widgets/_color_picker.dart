import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final Map<String, double> colorPainterSize = {
    'width': 300.0,
    'height': 250.0
  };
  final Map<String, double> huePainterSize = { 'width': 200.0, 'height': 13.0};
  final Map<String, double> alphaPainterSize = {
    'width': 200.0,
    'height': 13.0
  };

  @override
  State<StatefulWidget> createState() => new _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  double hue = 0.0;
  double saturation = 0.0;
  double value = 1.0;
  double alpha = 1.0;

  List<Map<String, List<String>>> colorTypes = [
    { 'HEX': ['R', 'G', 'B', 'A']},
    { 'RGB': ['R', 'G', 'B', 'A']},
    { 'HSL': ['H', 'S', 'L', 'A']},
  ];
  String colorType = 'HEX';
  List<String> colorValue = ['FF', 'FF', 'FF', '100'];

  Uint8List chessTexture = new Uint8List(0);

  getColorValue() {
    Color color = new HSVColor.fromAHSV(alpha, hue, saturation, value).toColor();
    switch (colorType) {
      case 'HEX':
        colorValue = [
          color.red.toRadixString(16).toUpperCase(),
          color.green.toRadixString(16).toUpperCase(),
          color.blue.toRadixString(16).toUpperCase(),
          (alpha * 100).toInt().toString() + ' %'
        ];
        break;
      case 'RGB':
        colorValue = [
          color.red.toString(),
          color.green.toString(),
          color.blue.toString(),
          (alpha * 100).toInt().toString() + ' %'
        ];
        break;
      case 'HSL':
        double s = 0.0, l = 0.0;
        l = (2 - saturation) * value / 2;
        if (l != 0) {
          if (l == 1) s = 0.0;
          else if (l < 0.5) s = saturation * value / (l * 2);
          else s = saturation * value / (2 - l * 2);
        }
        colorValue = [
          hue.toInt().toString(),
          (s * 100).round().toString() + ' %',
          (l * 100).round().toString() + ' %',
          (alpha * 100).toInt().toString() + ' %'
        ];
        break;
      default:
        break;
    }
  }

  @override
  initState() {
    super.initState();
    String baseEncodedImage = 'iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAIAAADZF8uwAAAAGUlEQVQYV2M4gwH+YwCGIasIUwhT25BVBADtzYNYrHvv4gAAAABJRU5ErkJggg==';
    chessTexture = BASE64.decode(baseEncodedImage);
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new LayoutBuilder(
          builder: (BuildContext context, BoxConstraints box) {
            return new Container( // build color picker
              width: widget.colorPainterSize['width'],
              height: widget.colorPainterSize['height'],
              child: new GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  RenderBox getBox = context.findRenderObject();
                  Offset localOffset = getBox.globalToLocal(
                      details.globalPosition);
                  setState(() {
                    saturation = localOffset.dx
                        .clamp(0.0, widget.colorPainterSize['width']) /
                        widget.colorPainterSize['width'];
                    value = 1 - localOffset.dy
                        .clamp(0.0, widget.colorPainterSize['height']) /
                        widget.colorPainterSize['height'];
                    getColorValue();
                  });
                },
                child: new CustomPaint(
                  painter: new ColorPainter(
                      hue, saturation: saturation, value: value),
                ),
              ),
            );
          },
        ),
        new Padding(padding: const EdgeInsets.all(10.0)),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container( // build color indicator
              width: 50.0,
              height: 50.0,
              decoration: new BoxDecoration(
                borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0)),
                border: new Border.all(color: new Color(0xffdddddd)),
                image: new DecorationImage(
                  image: new MemoryImage(chessTexture),
                  repeat: ImageRepeat.repeat,
                ),
              ),
              child: new ClipRRect(
                borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0)),
                child: new Material(
                  color: new HSVColor.fromAHSV(alpha, hue, saturation, value).toColor(),
                ),
              ),
            ),
            new Padding(padding: const EdgeInsets.only(right: 25.0)),
            new Column(
              children: <Widget>[
                new Container(
                  width: widget.huePainterSize['width'],
                  height: widget.huePainterSize['height'] * 3,
                  child: new CustomMultiChildLayout(
                    delegate: new _SliderLayout(),
                    children: <Widget>[
                      new LayoutId(
                        id: _SliderLayout.painter,
                        child: new ClipRRect(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(5.0)),
                          child: new CustomPaint(
                            painter: new HuePainter(),
                          ),
                        ),
                      ),
                      new LayoutId(
                        id: _SliderLayout.pointer,
                        child: new Transform(
                          transform: new Matrix4.identity()
                            ..translate(
                                widget.huePainterSize['width'] * hue / 360),
                          child: new CustomPaint(
                            painter: new HuePointerPainter(),
                          ),
                        ),
                      ),
                      new LayoutId(
                        id: _SliderLayout.gestureContainer,
                        child: new LayoutBuilder( // build hue slider
                          builder: (BuildContext context, BoxConstraints box) {
                            return new GestureDetector(
                              onPanUpdate: (DragUpdateDetails details) {
                                RenderBox getBox = context.findRenderObject();
                                Offset localOffset = getBox.globalToLocal(
                                    details.globalPosition);
                                setState(() {
                                  hue = localOffset.dx
                                      .clamp(
                                      0.0, widget.huePainterSize['width']) /
                                      widget.huePainterSize['width'] * 360;
                                  getColorValue();
                                });
                              },
                              child: new Container(
                                color: new Color(0),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  width: widget.alphaPainterSize['width'],
                  height: widget.alphaPainterSize['height'] * 3,
                  child: new CustomMultiChildLayout(
                    delegate: new _SliderLayout(),
                    children: <Widget>[
                      new LayoutId(
                        id: _SliderLayout.painter,
                        child: new ClipRRect(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(5.0)),
                          child: new CustomPaint(
                            painter: new AlphaPainter(),
                          ),
                        ),
                      ),
                      new LayoutId(
                        id: _SliderLayout.pointer,
                        child: new Transform(
                          transform: new Matrix4.identity()
                            ..translate(
                                widget.alphaPainterSize['width'] * alpha),
                          child: new CustomPaint(
                            painter: new AlphaPointerPainter(),
                          ),
                        ),
                      ),
                      new LayoutId(
                        id: _SliderLayout.gestureContainer,
                        child: new LayoutBuilder( // build transparent slider
                          builder: (BuildContext context, BoxConstraints box) {
                            return new GestureDetector(
                              onPanUpdate: (DragUpdateDetails details) {
                                RenderBox getBox = context.findRenderObject();
                                Offset localOffset = getBox.globalToLocal(
                                    details.globalPosition);
                                setState(() {
                                  alpha = localOffset.dx
                                      .clamp(
                                      0.0, widget.alphaPainterSize['width']) /
                                      widget.alphaPainterSize['width'];
                                  getColorValue();
                                });
                              },
                              child: new Container(
                                color: new Color(0),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        new Padding(padding: const EdgeInsets.all(10.0)),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new DropdownButton(
              value: colorType,
              onChanged: (String val) =>
                  setState(() {
                    colorType = val;
                    getColorValue();
                  }),
              items: colorTypes.map((Map<String, List> item) {
                return new DropdownMenuItem(
                  value: item.keys
                      .map((String key) => key)
                      .first,
                  child: new Text(item.keys
                      .map((String key) => key)
                      .first),
                );
              }).toList(),
            ),
          ]..addAll(colorValueLabels() ?? <Widget>[]),
        ),
      ],
    );
  }

  List<Widget> colorValueLabels() {
    List widget = colorTypes.map((Map<String, List<String>> item) {
      if (item.keys.first == colorType) {
        return item[colorType].map((String val) {
          return new Container(
            width: 50.0,
            height: 70.0,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Text(val, style: new TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0)),
                new Padding(padding: const EdgeInsets.only(top: 10.0)),
                new Text(colorValue[item[colorType].indexOf(val)]),
              ],
            ),
          );
        }).toList();
      }
    }).toList();
    widget.removeWhere((v) => v == null);
    return widget.first;
  }
}

class _SliderLayout extends MultiChildLayoutDelegate {
  static final String painter = 'painter';
  static final String pointer = 'pointer';
  static final String gestureContainer = 'gesturecontainer';

  @override
  void performLayout(Size size) {
    layoutChild(painter,
        new BoxConstraints.tightFor(
            width: size.width, height: size.height / 6));
    positionChild(painter, new Offset(0.0, size.height * 0.4));
    layoutChild(pointer,
        new BoxConstraints.tightFor(width: 5.0, height: size.height / 5));
    positionChild(pointer, new Offset(0.0, size.height * 0.4));
    layoutChild(gestureContainer,
        new BoxConstraints.tightFor(width: size.width, height: size.height));
    positionChild(gestureContainer, Offset.zero);
  }

  @override
  bool shouldRelayout(_SliderLayout oldDelegate) => false;
}

class ColorPainter extends CustomPainter {
  ColorPainter(this.hue, {
    this.saturation: 1.0,
    this.value: 0.0,
  });

  double hue;
  double saturation;
  double value;

  @override
  paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    Gradient gradientBW = new LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        new HSVColor.fromAHSV(1.0, 0.0, 0.0, 1.0).toColor(),
        new HSVColor.fromAHSV(1.0, 0.0, 0.0, 0.0).toColor(),
      ],
    );
    Gradient gradientColor = new LinearGradient(
      colors: [
        new HSVColor.fromAHSV(1.0, hue, 0.0, 1.0).toColor(),
        new HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor(),
      ],
    );
    canvas.drawRect(rect, new Paint()..shader = gradientBW.createShader(rect));
    canvas.drawRect(rect, new Paint()
      ..blendMode = BlendMode.multiply
      ..shader = gradientColor.createShader(rect));
    canvas.drawCircle(
        new Offset(size.width * saturation, size.height * (1 - value)),
        size.height * 0.04,
        new Paint()
          ..color = Colors.white
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class HuePainter extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    Gradient gradient = new LinearGradient(
        colors: [
          const HSVColor.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
        ]
    );
    canvas.drawRect(rect, new Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class HuePointerPainter extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    canvas.drawShadow(
      new Path()
        ..addOval(
          new Rect.fromCircle(center: Offset.zero, radius: size.width * 1.8),
        ),
      Colors.black,
      2.0,
      true,
    );
    canvas.drawCircle(
        new Offset(0.0, size.height * 0.4),
        size.height,
        new Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class AlphaPainter extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    Gradient gradient = new LinearGradient(
      colors: [
        Colors.black.withOpacity(0.0),
        Colors.black.withOpacity(1.0),
      ],
    );
    canvas.drawRect(rect, new Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class AlphaPointerPainter extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    canvas.drawShadow(
      new Path()
        ..addOval(
          new Rect.fromCircle(center: Offset.zero, radius: size.width * 1.8),
        ),
      Colors.black,
      2.0,
      true,
    );
    canvas.drawCircle(
        new Offset(0.0, size.height * 0.4),
        size.height,
        new Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

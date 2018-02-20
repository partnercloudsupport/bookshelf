import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  double hue = 60.0;
  double saturation = 1.0;
  double value = 1.0;
  double alpha = 1.0;

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
          width: 300.0,
          height: 250.0,
          child: new GestureDetector(
            onPanStart: (DragStartDetails details) {
              print(details);
            },
            child: new CustomPaint(
              painter: new ColorPainter(hue),
            ),
          ),
        ),
        new Padding(padding: const EdgeInsets.all(10.0)),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new ClipRRect(
              borderRadius: const BorderRadius.all(const Radius.circular(50.0)),
              child: new Container(
                width: 50.0,
                height: 50.0,
                color: new HSVColor.fromAHSV(alpha, hue, saturation, value).toColor(),
              ),
            ),
            new Padding(padding: const EdgeInsets.only(right: 25.0)),
            new Container(
              width: 220.0,
              height: 10.0,
              child: new ClipRRect(
                borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
                child: new CustomPaint(
                  painter: new HuePainter(),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

double _getValueFromGlobalPosition(Offset globalPosition) {
  final double visualPosition = (globalToLocal(globalPosition).dx - _kReactionRadius) / _trackLength;
  return _getValueFromVisualPosition(visualPosition);
}

class ColorPainter extends CustomPainter {
  ColorPainter(this.hue);

  double hue;

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
    Paint paint = new Paint()..blendMode = BlendMode.multiply;
    canvas.drawRect(rect, paint..shader = gradientColor.createShader(rect));
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
class AlphaPainter extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
//    canvas.drawColor(color, blendMode)
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

}
import 'package:flutter/material.dart';
import 'dart:math' as math;

//------------------------------------------------Widget
// Widget For Rokkhi LOGO
Widget rokkhiLogoImage() {
  return Padding(
    padding: const EdgeInsets.only(top: 90.0, bottom: 140.0),
    child: Center(
      child: Image.asset('images/Rokkhi_LOGO.png'),
    ),
  );
}

// Widget For Shahidul LOGO
Widget shahidulLogoImage() {
  return Image.asset('images/ShahidulBari_LOGO.png');
}

// Widget For Custom Appbar
Widget logoAppBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Image.asset(
        'images/ShahidulBari_LOGO.png',
        height: 80,
        width: 100,
      ),
      Image.asset(
        'images/Rokkhi_LOGO.png',
        height: 80,
        width: 60,
      ),
    ],
  );
}

Widget patrolLogo() {
  return Padding(
    padding: EdgeInsets.all(15.0),
    child: Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              'images/Rokkhi_LOGO.png',
              height: 50,
              width: 80,
            )),
        Row(
          children: [
            // Image.asset(
            //   'images/ShahidulBari_LOGO.png',
            //   height: 40,
            // ),
            Text('11'),
            Spacer(),
            Image.asset(
              'images/Patrol_LOGO.png',
              height: 150,
            ),
          ],
        ),
      ],
    ),
  );
}

//------------------------------------------------Style
// Textfield UI Design
InputDecoration textfeildDesign() {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: rokkhiColor, width: 0.4),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 0.4),
    ),
    hintText: '0172345678',
  );
}

// Button UI Design
ButtonStyle buttonStyle(Color foregroundColor, Color backgroundColor) {
  return OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0))),
    primary: foregroundColor,
    backgroundColor: backgroundColor,
  );
}

//------------------------------------------------Design
FontWeight defaultFontWeight = FontWeight.w400;
Color rokkhiColor = Colors.red;

//------------------------------------------------Dashed Box
class DashedRect extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double gap;
  final bool isDutyTime;

  Widget _dutyTimeWidget(bool isDutyTime) {
    if (!isDutyTime)
      return Text('This is not your duty time.');
    else
      return Text('This is your duty time.');
  }

  DashedRect(
      {this.color = Colors.grey,
      this.strokeWidth = 1.0,
      this.gap = 5.0,
      this.isDutyTime = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.all(strokeWidth / 2),
        child: CustomPaint(
          painter:
              DashRectPainter(color: color, strokeWidth: strokeWidth, gap: gap),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: _dutyTimeWidget(this.isDutyTime),
            ),
          ),
        ),
      ),
    );
  }
}

class DashRectPainter extends CustomPainter {
  double strokeWidth;
  Color color;
  double gap;

  DashRectPainter(
      {this.strokeWidth = 5.0, this.color = Colors.grey, this.gap = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double x = size.width;
    double y = size.height;

    Path _topPath = getDashedPath(
      a: math.Point(0, 0),
      b: math.Point(x, 0),
      gap: gap,
    );

    Path _rightPath = getDashedPath(
      a: math.Point(x, 0),
      b: math.Point(x, y),
      gap: gap,
    );

    Path _bottomPath = getDashedPath(
      a: math.Point(0, y),
      b: math.Point(x, y),
      gap: gap,
    );

    Path _leftPath = getDashedPath(
      a: math.Point(0, 0),
      b: math.Point(0.001, y),
      gap: gap,
    );

    canvas.drawPath(_topPath, dashedPaint);
    canvas.drawPath(_rightPath, dashedPaint);
    canvas.drawPath(_bottomPath, dashedPaint);
    canvas.drawPath(_leftPath, dashedPaint);
  }

  Path getDashedPath({
    @required math.Point<double> a,
    @required math.Point<double> b,
    @required gap,
  }) {
    Size size = Size(b.x - a.x, b.y - a.y);
    Path path = Path();
    path.moveTo(a.x, a.y);
    bool shouldDraw = true;
    math.Point currentPoint = math.Point(a.x, a.y);

    num radians = math.atan(size.height / size.width);

    num dx = math.cos(radians) * gap < 0
        ? math.cos(radians) * gap * -1
        : math.cos(radians) * gap;

    num dy = math.sin(radians) * gap < 0
        ? math.sin(radians) * gap * -1
        : math.sin(radians) * gap;

    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {
      shouldDraw
          ? path.lineTo(currentPoint.x, currentPoint.y)
          : path.moveTo(currentPoint.x, currentPoint.y);
      shouldDraw = !shouldDraw;
      currentPoint = math.Point(
        currentPoint.x + dx,
        currentPoint.y + dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

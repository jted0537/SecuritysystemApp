import 'package:flutter/material.dart';
import 'package:security_system/components/preferences.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

// AppointedRouteMenu
class AppointedRouteMenu extends StatefulWidget {
  @override
  _AppointedRouteMenuState createState() => _AppointedRouteMenuState();
}

class _AppointedRouteMenuState extends State<AppointedRouteMenu> {
  DateTime now;
  DateTime date;
  String formattedDate;
  bool isDutyTime;

  // It is Duty time or not
  Widget _dutyTimeWidget(bool isDutyTime) {
    if (!isDutyTime)
      return Text(
        'Not Assigned Yet',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: defaultFontWeight,
          decoration: TextDecoration.underline,
        ),
      );
    else
      return Text(
        'This is your duty time',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: defaultFontWeight,
          decoration: TextDecoration.underline,
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);
    formattedDate = DateFormat('dd/MM/yyyy').format(now);
    this.isDutyTime = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              logoAppBar(),
              // Appointed Route Button
              Container(
                width: double.infinity,
                child: OutlinedButton(
                  // For 'Submit your fingerprint button
                  child: Column(
                    children: [
                      Image.asset('images/marker.png',
                          height: 25.0, width: 25.0),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text('Appointed Route',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w700,
                          )),
                      SizedBox(
                        height: 5.0,
                      ),
                      _dutyTimeWidget(this.isDutyTime),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/ad');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                  width: double.infinity,
                  color: Colors.black12,
                  child: DashedRect(
                    color: Colors.grey[300],
                    strokeWidth: 2.0,
                    gap: 3.0,
                    isDutyTime: this.isDutyTime,
                  )),
              SizedBox(
                height: 20.0,
              ),
              // Checkpoints
              Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Text('Checkpoints',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13.0,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      child: Text(
                        'See All',
                        style: TextStyle(color: rokkhiColor),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 0.6,
                color: Colors.black,
              ),

              // EXIT Button
              OutlinedButton(
                  style: buttonStyle(Colors.grey, Colors.white),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text('EXIT')),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------------
// For dashed box
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

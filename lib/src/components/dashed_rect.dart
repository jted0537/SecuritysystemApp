import 'package:flutter/material.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/src/components/dialogs.dart';
import 'dart:math' as math;
import 'package:security_system/main.dart';
import 'package:security_system/src/services/local_notification_service.dart';

//------------------------------------------------Dashed Box
class DashedRect extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double gap;
  final bool isDutyTime;
  final String navigation;
  final LocalNotification localNotification;
  final String type;

  DashedRect(
      {this.color = Colors.grey,
      this.strokeWidth = 1.0,
      this.gap = 5.0,
      this.isDutyTime = false,
      this.navigation = '',
      this.localNotification,
      this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: CustomPaint(
        painter:
            DashRectPainter(color: color, strokeWidth: strokeWidth, gap: gap),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
            child: type == 'patrol'
                ? PatrolDutyTimeWidget(this.isDutyTime, this.navigation)
                : StationDutyTimeWidget(
                    this.isDutyTime, this.navigation, this.localNotification),
          ),
        ),
      ),
    );
  }
}

// Stationary Guard Dashed Rectangle Box
class PatrolDutyTimeWidget extends StatefulWidget {
  final bool isDutyTime;
  final String navigation;
  //inal LocalNotification localNotification;

  PatrolDutyTimeWidget(this.isDutyTime, this.navigation);

  @override
  _PatrolDutyTimeWidgetState createState() => _PatrolDutyTimeWidgetState();
}

class _PatrolDutyTimeWidgetState extends State<PatrolDutyTimeWidget> {
  Widget build(BuildContext context) {
    if (!widget.isDutyTime)
      return Column(
        children: [
          Text('This is not your duty time.'),
          SizedBox(height: 15.0), //Navigator.pushNamed(context, navigation)
        ],
      );
    else
      return Column(
        children: [
          Text('This is your duty time.'),
          SizedBox(height: 15.0),
          Text(
            loginGuardViewModel.status
                ? 'You have your work.'
                : 'You are not assigned yet.',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: defaultFontWeight,
              decoration: TextDecoration.underline,
            ),
          ),
          TextButton(
            child: Text(
              loginGuardViewModel.status ? 'Go to work!' : 'Start work!',
              style: TextStyle(color: rokkhiColor),
            ),
            onPressed: () async {
              if (loginGuardViewModel.status == false) {
                setState(() {
                  loginGuardViewModel.loginGuard.status = true;
                });
                showLoadingDialog(context);
                await currentWorkViewModel.fetchNewWork(loginGuardViewModel.id);
                // await widget.localNotification.cancelAllNotification();
                // for (int i = 0;
                //     i < currentWorkViewModel.alarmTimeList.length;
                //     i++) {
                //   DateTime now = DateTime.now();
                //   String each = currentWorkViewModel.alarmTimeList[i];
                //   int hour = int.parse(each.split(":")[0]);
                //   int minute = int.parse(each.split(":")[1]);
                //   await widget.localNotification.showNotification(
                //       now.year, now.month, now.day, hour, minute);
                // }
                hideLoadingDialog(context);
              }
              Navigator.pushNamed(context, widget.navigation);
            },
          ),
        ],
      );
  }
}

// Stationary Guard Dashed Rectangle Box
class StationDutyTimeWidget extends StatefulWidget {
  final bool isDutyTime;
  final String navigation;
  final LocalNotification localNotification;

  StationDutyTimeWidget(
      this.isDutyTime, this.navigation, this.localNotification);

  @override
  _StationDutyTimeWidgetState createState() => _StationDutyTimeWidgetState();
}

class _StationDutyTimeWidgetState extends State<StationDutyTimeWidget> {
  Widget build(BuildContext context) {
    if (!widget.isDutyTime)
      return Column(
        children: [
          Text('This is not your duty time.'),
          SizedBox(height: 15.0), //Navigator.pushNamed(context, navigation)
        ],
      );
    else
      return Column(
        children: [
          Text('This is your duty time.'),
          SizedBox(height: 15.0),
          Text(
            loginGuardViewModel.status
                ? 'You have your work.'
                : 'You are not assigned yet.',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: defaultFontWeight,
              decoration: TextDecoration.underline,
            ),
          ),
          TextButton(
            child: Text(
              loginGuardViewModel.status ? 'Go to work!' : 'Start work!',
              style: TextStyle(color: rokkhiColor),
            ),
            onPressed: () async {
              if (loginGuardViewModel.status == false) {
                setState(() {
                  loginGuardViewModel.loginGuard.status = true;
                });
                showLoadingDialog(context);
                await currentWorkViewModel.fetchNewWork(loginGuardViewModel.id);
                await widget.localNotification.cancelAllNotification();
                for (int i = 0;
                    i < currentWorkViewModel.alarmTimeList.length;
                    i++) {
                  DateTime now = DateTime.now();
                  String each = currentWorkViewModel.alarmTimeList[i];
                  int hour = int.parse(each.split(":")[0]);
                  int minute = int.parse(each.split(":")[1]);
                  await widget.localNotification.showNotification(
                      now.year, now.month, now.day, hour, minute);
                }
                hideLoadingDialog(context);
              }
              Navigator.pushNamed(context, widget.navigation);
            },
          ),
        ],
      );
  }
}

// For Dashed Rectangle Box
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

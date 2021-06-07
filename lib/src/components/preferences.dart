import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

//------------------------------------------------Widget
// Widget For Rokkhi LOGO
Widget rokkhiLogoImage() {
  return Padding(
    padding: const EdgeInsets.only(top: 90.0, bottom: 130.0),
    child: Center(
      child: Image.asset(
        'images/Rokkhi_LOGO.png',
        height: 70.0,
        width: 110.0,
      ),
    ),
  );
}

// Widget For Shahidul LOGO
Widget shahidulLogoImage() {
  return Image.asset('images/ShahidulBari_LOGO.png');
}

// Widget For Custom Appbar
Widget logoAppBar(String guardName, String type) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Image.asset(
            'images/Shield_LOGO.png',
            height: 25,
            width: 25,
          ),
          SizedBox(
            width: 5.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                guardName,
                style: TextStyle(fontWeight: titleFontWeight),
              ),
              if (type == 'patrol')
                Text('Patrolling Guard',
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: defaultFontWeight,
                        color: Colors.grey))
              else
                Text('Stationary Guard',
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: defaultFontWeight,
                        color: Colors.grey)),
            ],
          ),
        ],
      ),
      Image.asset(
        'images/Rokkhi_LOGO.png',
        //height: 90,
        width: 70,
      ),
    ],
  );
}

// Widget for patrol logo (Rokkhi, Guard (name,type), Patrol image)
Widget patrolLogo(String guardName, String type) {
  return Padding(
    padding: EdgeInsets.fromLTRB(15.0, 10.0, 30.0, 0.0),
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
            Image.asset(
              'images/Shield_LOGO.png',
              height: 35,
              width: 35,
            ),
            SizedBox(
              width: 5.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(guardName,
                    style: TextStyle(
                      fontWeight: titleFontWeight,
                      fontSize: 17.0,
                    )),
                if (type == 'patrol')
                  Text('Patrolling Guard',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: defaultFontWeight,
                          color: Colors.grey))
                else
                  Text('Stationary Guard',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: defaultFontWeight,
                          color: Colors.grey)),
              ],
            ),
            Spacer(),
            Image.asset(
              'images/Patrol_LOGO.png',
              width: 140,
            ),
          ],
        ),
      ],
    ),
  );
}

// Widget for topRight dismiss button
Widget topRightDismissButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 40.0,
        child: TextButton(
          child: Image.asset(
            'images/Dismiss_LOGO.png',
            width: 22.0,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    ],
  );
}

// Widget for exit button, It will pop navigate (count) times
Widget exitButton(BuildContext context, int count) {
  // EXIT Button
  return OutlinedButton(
      style: buttonStyle(Colors.grey, Colors.white),
      child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0), child: Text('EXIT')),
      onPressed: () {
        for (var a = 0; a < count; a++) {
          Navigator.of(context).pop();
        }
      });
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
FontWeight titleFontWeight = FontWeight.bold;
FontWeight defaultFontWeight = FontWeight.w400;
Color rokkhiColor = Colors.red;

//------------------------------------------------Dashed Box
class DashedRect extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double gap;
  final bool isDutyTime;
  final String navigation;
  final String type;

  Widget _dutyTimeWidget(
      BuildContext context, bool isDutyTime, String navigation) {
    if (!isDutyTime)
      return TextButton(
        child: Text('This is not your duty time.'),
        onPressed: () {
          Navigator.pushNamed(context, navigation);
        },
      );
    else
      return TextButton(
        child: Text('This is your duty time.'),
        onPressed: () {
          Navigator.pushNamed(context, navigation);
        },
      );
  }

  DashedRect(
      {this.color = Colors.grey,
      this.strokeWidth = 1.0,
      this.gap = 5.0,
      this.isDutyTime = false,
      this.navigation = '',
      this.type = 'patrol',});

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
              child: _dutyTimeWidget(context, this.isDutyTime, this.navigation),
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

//------------------------------------Show Dialogs
// Alert Dialog when user failed to login.
void loginFailedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Login Failed"),
        content: Text("Incorrect Employee ID or Phone number."),
        actions: [
          TextButton(
            child: Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}

// Alert Dialog when user failed to login.
void internetConnectionFailedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("No internet connection"),
        content: Text("Please check your internet connection and try again."),
        actions: [
          TextButton(
            child: Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}

// Logging in Dialog
void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(rokkhiColor),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text("Please wait",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                )),
            Text('Logging in...'),
          ],
        ),
      );
    },
  );
}

// Pop Dialog
void hideLoadingDialog(BuildContext context) {
  Navigator.pop(context);
}

// If device has no biometric authentication information
void noBioMetricInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text("Authentication Failed"),
        content: Text("You should update device biometrics and security first"),
        actions: [
          TextButton(
            child: Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}

// If device has no function for Biometric authentication
void notProvideBioMetricDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text("Authentication Failed"),
        content: Text("Device has no biometric authentication functions."),
        actions: [
          TextButton(
            child: Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}

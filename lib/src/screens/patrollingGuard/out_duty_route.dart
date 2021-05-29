import 'package:flutter/material.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/main.dart';
import 'package:intl/intl.dart';
import 'package:security_system/src/models/route.dart' as rt;

// AppointedRouteMenu
class OutDutyRoute extends StatefulWidget {
  @override
  _OutDutyRouteState createState() => _OutDutyRouteState();
}

class _OutDutyRouteState extends State<OutDutyRoute> {
  bool isDutyTime;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);
    formattedDate = DateFormat('dd.MM.yyyy').format(now);
    if (now.hour * 60 + now.minute <
            loginGuardViewModel.endTimeHour * 60 +
                loginGuardViewModel.endTimeMinute &&
        now.hour * 60 + now.minute >
            loginGuardViewModel.startTimeHour * 60 +
                loginGuardViewModel.startTimeMinute)
      this.isDutyTime = true;
    else
      this.isDutyTime = false;
  }

  @override
  Widget build(BuildContext context) {
    // Using WillPopScope for block the return with device back button
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  // Logo App Bar
                  logoAppBar(
                      loginGuardViewModel.guardName, loginGuardViewModel.type),
                  SizedBox(height: 20.0),
                  // Appointed Route Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.grey[200],
                        )),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 25.0),
                      child: Column(
                        children: [
                          Image.asset('images/marker.png',
                              height: 25.0, width: 25.0),
                          SizedBox(height: 10.0),
                          Text('Appointed Route',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.0,
                                fontWeight: titleFontWeight,
                              )),
                          SizedBox(height: 10.0),
                          Text(
                            '1',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: defaultFontWeight,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Dashed Rectangle Box
                  Container(
                      width: double.infinity,
                      color: Colors.black12,
                      child: DashedRect(
                        color: Colors.grey[300],
                        strokeWidth: 2.0,
                        gap: 3.0,
                        isDutyTime: this.isDutyTime,
                        navigation: '/inDutyRoute',
                      )),
                  SizedBox(height: 20.0),
                  _checkPointsList(context, true),
                  SizedBox(height: 10.0),
                  // EXIT Button(Back to login screen)
                  exitButton(context, 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget for CheckPoints list(with or not 'See all' button)
Widget _checkPointsList(BuildContext context, bool saButton) {
  return Column(
    children: [
      // Checkpoints List
      Row(
        children: [
          Text('Checkpoints',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(width: 10.0),
          Text(
            formattedDate,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13.0,
            ),
          ),
          Spacer(),
          // Show see all button?
          if (saButton)
            TextButton(
              child: Text(
                'See All',
                style: TextStyle(color: rokkhiColor),
              ),
              onPressed: () {
                // Show checkpoints list with bottomsheet
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                  ),
                  isScrollControlled: true,
                  builder: (context) => Container(
                    height: 400.0,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      child: Column(
                        children: [
                          topRightDismissButton(context),
                          _checkpointsBottomSheet(context),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      if (!saButton) SizedBox(height: 10.0),
      Divider(
        thickness: 1.0,
        color: Colors.black,
      ),
      FutureBuilder<rt.Route>(
          future: loginRouteViewModel.fetchRoute(loginId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  for (int i = 0; i < snapshot.data.totalCheckpointNum; i++)
                    Column(
                      children: [
                        _checkpoint(
                            snapshot.data.routeTitle,
                            snapshot.data.checkpoints[i].sequenceNum,
                            snapshot.data.checkpoints[i].frequency),
                        Divider(
                          thickness: 1.0,
                        ),
                      ],
                    ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(rokkhiColor),
            );
          }),
    ],
  );
}

Widget _checkpointsBottomSheet(BuildContext context) {
  return Column(
    children: [
      // Checkpoints List
      Row(
        children: [
          Text('Checkpoints',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(width: 10.0),
          Text(
            formattedDate,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13.0,
            ),
          ),
          Spacer(),
        ],
      ),
      SizedBox(height: 10.0),
      Divider(
        thickness: 1.0,
        color: Colors.black,
      ),
      for (int i = 0; i < loginRouteViewModel.totalCheckPointNum; i++)
        Column(
          children: [
            _checkpoint(
                loginRouteViewModel.routeTitle,
                loginRouteViewModel.loginRoute.checkpoints[i].sequenceNum,
                loginRouteViewModel.loginRoute.checkpoints[i].frequency),
            Divider(
              thickness: 1.0,
            ),
          ],
        ),
      SizedBox(height: 10.0),
      exitButton(context, 1),
    ],
  );
}

// For each attendance
Widget _checkpoint(String routeTitle, int sequenceNum, int frequency) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 13.0),
    child: Row(
      children: [
        Text(routeTitle + ' ' + sequenceNum.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              fontWeight: titleFontWeight,
            )),
        Spacer(),
        Text(
          '0' + ' / ' + frequency.toString(),
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13.0,
            fontWeight: defaultFontWeight,
          ),
        ),
      ],
    ),
  );
}

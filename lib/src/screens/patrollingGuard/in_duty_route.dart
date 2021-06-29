import 'dart:async';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:security_system/src/services/local_auth_service.dart';
import 'package:security_system/src/services/web_service.dart';
import 'package:security_system/src/models/chckpoint.dart';
import 'package:security_system/src/screens/patrollingGuard/view_map.dart';
import 'package:security_system/src/models/work.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/main.dart';

class InDutyRoute extends StatefulWidget {
  @override
  _InDutyRouteState createState() => _InDutyRouteState();
}

// the next checkpoint to be visited
int cpSeqNum = 1;
// to display the message in view map
bool isStartPatrol = false;

class _InDutyRouteState extends State<InDutyRoute> {
  // authentication if the guard is in checkpoint
  Future<bool> periodicAuthentication() async {
    final isAuthenticated = await LocalAuthService.authenticate();
    if (isAuthenticated == BioMetricLogin.Success) {
      // If Biometric authentication success
      return true;
    } else if (isAuthenticated == BioMetricLogin.NoBioMetricInfo) {
      // If device has no biometric authentication information, alert message pop
      return false;
    } else if (isAuthenticated == BioMetricLogin.DeviceNotProvide) {
      // If device has no biometric auth function
      return false;
    } else {
      return false;
    }
  }

  // check if the guard is in checkpoint
  bool isCheckPoint(double curLat, double curLng) {
    List<CheckPoint> curCheckpoints =
        loginRouteViewModel.loginRoute.checkpoints;

    // approximate radius of earth in km
    double R = 6373.0;
    double lat1 = vm.radians(curLat);
    double lng1 = vm.radians(curLng);
    double lat2 = vm.radians(curCheckpoints[cpSeqNum - 1].latitude);
    double lng2 = vm.radians(curCheckpoints[cpSeqNum - 1].longitude);

    double dlng1 = lng2 - lng1;
    double dlat1 = lat2 - lat1;

    double a1 =
        pow(sin(dlat1 / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlng1 / 2), 2);
    double c1 = 2 * atan2(sqrt(a1), sqrt(1 - a1));

    double dist1 = R * c1;
    // change distance into meter
    double result1 = dist1 * 1000;

    // accuracy : +- 30m
    if (result1 <= 30) {
      now = DateTime.now();
      lastHour = now.hour;
      lastMinute = now.minute;
      return true;
    } else
      return false;
  }

  @override
  void initState() {
    super.initState();

    print(loginGuardViewModel.frequency);

    // calculate formattedDate
    now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);
    formattedDate = DateFormat('dd.MM.yyyy').format(now);

    // initiate lastHour & lastMinute
    lastHour = now.hour;
    lastMinute = now.minute;

    // set the 5 seconds timer
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => alarmExpired());
  }

  // when the timer alarm is triggered
  void alarmExpired() async {
    timer.cancel();

    var curLocation = await locationTracker.getLocation();

    bool isCP =
        isCheckPoint(curLocation.latitude, curLocation.longitude);
    bool isAuth = false;

    if (isCP) {
      // authenticate if in checkpoint
      isAuth = await periodicAuthentication();
      isStartPatrol = true;
      // send gps info to the server
      await WebService().postGPSReply(
          'patrol',
          cpSeqNum,
          currentWorkViewModel.workID,
          curLocation.latitude,
          curLocation.longitude,
          isCP,
          isAuth);
      if (isAuth) {
        // if authentication is succeeded, cpSeqNum is moved to the next checkpoint
        if (cpSeqNum >= loginRouteViewModel.checkPoints.length)
          cpSeqNum = 1;
        else
          cpSeqNum = cpSeqNum + 1;
      }
    } else {
      // send gps info to the server
      await WebService().postGPSReply(
          'patrol',
          cpSeqNum,
          currentWorkViewModel.workID,
          curLocation.latitude,
          curLocation.longitude,
          isCP,
          isAuth);
    }

    setState(() {});
    // calculate the working finish time
    if (now.hour * 60 + now.minute >=
        loginGuardViewModel.endTimeHour * 60 +
            loginGuardViewModel.endTimeMinute) {
      return;
    }
    // if working time is not done, reset the timer
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => alarmExpired());
  }

  @override
  Widget build(BuildContext context) {
    // Using WillPopScope for block the return with device back button
    return Scaffold(
      backgroundColor: Colors.grey[150],
      body: SafeArea(
        child: CustomScrollView(
          // Using CustomScrollView and Silver for using expanded scroll view
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  // Company Logo Images (Rokkhi, Guard name, Patrol image)
                  patrolLogo(
                      loginGuardViewModel.guardName, loginGuardViewModel.type),
                  // Widgets in cornerRadiusBox
                  _inCornerRadiusBox(context, formattedDate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widgets in cornerRadiusBox
Widget _inCornerRadiusBox(BuildContext context, String formattedDate) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300],
                offset: Offset(0, 0),
                blurRadius: 3.0,
                spreadRadius: 0.3),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
          )),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Appointed Route Widget
            SizedBox(height: 10.0),
            Image.asset('images/marker.png', height: 25.0, width: 25.0),
            SizedBox(height: 10.0),
            Text('Appointed Route',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: titleFontWeight,
                )),
            SizedBox(height: 5.0),
            Text(
              loginRouteViewModel.routeTitle,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: defaultFontWeight,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 25.0),

            // CheckPoint, View Map button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CheckPoint Button
                _outLinedButton(
                    context, 'images/CheckPoint_LOGO.png', 'CheckPoints'),
                SizedBox(width: 5.0),
                // ViewMap Button
                _outLinedButton(context, 'images/ViewMap_LOGO.png', 'View Map'),
              ],
            ),
            SizedBox(height: 25.0),

            // Checkpoints List
            Row(
              children: [
                Text('Checkpoints',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  width: 10.0,
                  height: 40.0,
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1.0,
              color: Colors.black,
            ),
            FutureBuilder<Work>(
                // checkpoints list of the current route
                future: currentWorkViewModel.getWork(loginGuardViewModel.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (int i = 0;
                            i < snapshot.data.alarmTimeList.length;
                            i++)
                          Column(
                            children: [
                              _checkpoint(
                                  loginRouteViewModel.routeTitle,
                                  loginRouteViewModel
                                      .checkPoints[i].sequenceNum,
                                  snapshot.data.responseCntList[i],
                                  snapshot.data.alarmTimeList[i]),
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
                  // during fetch, display circular progress indicator
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(rokkhiColor),
                  );
                }),
            SizedBox(height: 20.0),
            // EXIT button
            exitButton(context, 1),
          ],
        ),
      ),
    ),
  );
}

// For CheckPoint button and ViewMap button
Widget _outLinedButton(BuildContext context, String imageAsset, String type) {
  return OutlinedButton(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 40.0),
      child: Column(
        children: [
          Image.asset(
            imageAsset,
            height: 30.0,
            width: 30.0,
          ),
          SizedBox(height: 10.0),
          Text(
            type,
            style: TextStyle(
                color: Colors.black,
                fontSize: 13.0,
                fontWeight: defaultFontWeight),
          ),
        ],
      ),
    ),
    onPressed: () {
      if (type != 'CheckPoints')
        Navigator.pushNamed(context, '/viewMap');
      else
        _checkpointsBottomSheet(context);
    },
  );
}

// to show all the checkpoints in the separate bottom sheet
void _checkpointsBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
            child: Container(
              height: 400.0,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    topRightDismissButton(context),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Checkpoints',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13.0,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1.0,
                      color: Colors.black,
                    ),
                    for (int i = 0;
                        i < loginRouteViewModel.totalCheckPointNum;
                        i++)
                      Column(
                        children: [
                          _checkpoint(
                              loginRouteViewModel.routeTitle,
                              loginRouteViewModel.checkPoints[i].sequenceNum,
                              currentWorkViewModel.responseCntList[i],
                              currentWorkViewModel.alarmTimeList[i]),
                          Divider(
                            thickness: 1.0,
                          ),
                        ],
                      ),
                    SizedBox(height: 20.0),
                    exitButton(context, 1),
                  ],
                ),
              ),
            ),
          ));
}

// For each checkpoint
Widget _checkpoint(String routeTitle, int sequenceNum, int curFrequency,
    String totalFrequency) {
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
          curFrequency.toString() + ' / ' + totalFrequency,
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

import 'package:flutter/material.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/src/components/dialogs.dart';
import 'package:security_system/main.dart';
import 'package:intl/intl.dart';
import 'package:security_system/src/services/local_auth_service.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:security_system/main.dart';
import 'package:security_system/src/services/web_service.dart';
import 'package:security_system/src/models/chckpoint.dart';
import 'dart:async';
import 'dart:ui';
import 'dart:math';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:security_system/src/screens/patrollingGuard/view_map.dart';
import 'package:security_system/src/models/route.dart' as rt;

Timer timer;
int cpSeqNum = 0;

class InDutyRoute extends StatefulWidget {
  @override
  _InDutyRouteState createState() => _InDutyRouteState();
}

class _InDutyRouteState extends State<InDutyRoute> {
  int counter = 0;

  Future<bool> periodicAuthentication() async {
    final isAuthenticated = await LocalAuthService.periodicAuthenticate();

    if (isAuthenticated == BioMetricLogin.Success) {
      // If Biometric authentication success
      return true;
    } else if (isAuthenticated == BioMetricLogin.NoBioMetricInfo) {
      // If device has no biometric authentication information, alert message pop
      noBioMetricInfoDialog(context);
    } else if (isAuthenticated == BioMetricLogin.DeviceNotProvide) {
      // If device has no biometric auth function
      notProvideBioMetricDialog(context);
    } else {
      return false;
    }
  }

  void updateSeqNum(double curLat, double curLng) {
    List<CheckPoint> curCheckpoints =
        loginRouteViewModel.loginRoute.checkpoints;
    var nextSeqNum;
    if (cpSeqNum >= curCheckpoints.length) {
      nextSeqNum = 0;
    } else
      nextSeqNum = cpSeqNum + 1;

    // approximate radius of earth in km
    double R = 6373.0;
    var lat1 = vm.radians(curLat);
    var lng1 = vm.radians(curLng);
    var lat2 = vm.radians(curCheckpoints[nextSeqNum].latitude);
    var lng2 = vm.radians(curCheckpoints[nextSeqNum].longitude);

    var dlng = lng2 - lng1;
    var dlat = lat2 - lat1;

    var a =
        pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlng / 2), 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    var dist = R * c;
    // change distance into meter
    var result = dist * 1000;

    // accuracy : +- 20m
    if (result <= 20) {
      // update check point seq num & last visit time
      cpSeqNum++;
      now = DateTime.now();
      lastHour = now.hour;
      lastMinute = now.minute;
    }
    return;
  }

  bool isCheckPoint(double curLat, double curLng) {
    List<CheckPoint> curCheckpoints =
        loginRouteViewModel.loginRoute.checkpoints;
    var nextSeqNum;
    if (cpSeqNum >= curCheckpoints.length) {
      nextSeqNum = 0;
    } else
      nextSeqNum = cpSeqNum + 1;

    // approximate radius of earth in km
    double R = 6373.0;
    var lat1 = vm.radians(curLat);
    var lng1 = vm.radians(curLng);
    var lat2 = vm.radians(curCheckpoints[cpSeqNum].latitude);
    var lng2 = vm.radians(curCheckpoints[cpSeqNum].longitude);
    var lat3 = vm.radians(curCheckpoints[nextSeqNum].latitude);
    var lng3 = vm.radians(curCheckpoints[nextSeqNum].longitude);

    var dlng1 = lng2 - lng1;
    var dlat1 = lat2 - lat1;
    var dlng2 = lng3 - lng1;
    var dlat2 = lat3 - lat1;

    var a1 =
        pow(sin(dlat1 / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlng1 / 2), 2);
    var c1 = 2 * atan2(sqrt(a1), sqrt(1 - a1));
    var a2 =
        pow(sin(dlat2 / 2), 2) + cos(lat1) * cos(lat3) * pow(sin(dlng2 / 2), 2);
    var c2 = 2 * atan2(sqrt(a2), sqrt(1 - a2));

    var dist1 = R * c1;
    var dist2 = R * c2;
    // change distance into meter
    var result1 = dist1 * 1000;
    var result2 = dist2 * 1000;

    // accuracy : +- 20m
    if (result1 <= 20)
      return true;
    else if (result2 <= 20) {
      // update check point seq num & last visit time
      cpSeqNum++;
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

    now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);
    formattedDate = DateFormat('dd.MM.yyyy').format(now);

    // initiate lastHour & lastMinute
    lastHour = now.hour;
    lastMinute = now.minute;

    bg.BackgroundGeolocation.ready(bg.Config(
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 10.0,
            stopOnTerminate: false,
            startOnBoot: true,
            debug: false,
            logLevel: bg.Config.LOG_LEVEL_OFF))
        .then((bg.State state) {
      if (!state.enabled) {
        // start background geolocation
        bg.BackgroundGeolocation.start();
      }
    });

    bg.BackgroundGeolocation.changePace(true);
    //timer = Timer.periodic(Duration(seconds: 150), (Timer t) => alarmExpired());
  }

  void alarmExpired() async {
    counter += 150;

    var location = await bg.BackgroundGeolocation.getCurrentPosition();
    // for every frequency, send to the web
    if (counter % (loginGuardViewModel.frequency * 60) == 0) {
      bool isAuth = await periodicAuthentication();
      print("is auth: $isAuth");
      print(
          '[location] - lat: ${location.coords.latitude} & lng: ${location.coords.longitude}');
      bool isCP;
      if (isAuth == true) {
        isCP =
            isCheckPoint(location.coords.latitude, location.coords.longitude);
      } else {
        isCP = false;
      }
      print("is check point: $isCP");
      WebService().postGPSReply('patrol', cpSeqNum, currentWorkViewModel.workID,
          location.coords.latitude, location.coords.longitude, isCP, isAuth);
    }
    // for every 2m30sec, update seqNum
    updateSeqNum(location.coords.latitude, location.coords.longitude);
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
                  // RaisedButton(onPressed: ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
      if (type != 'CheckPoint') Navigator.pushNamed(context, '/viewMap');
    },
  );
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
            SizedBox(height: 20.0),

            // CheckPoint, View Map button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CheckPoint Button
                _outLinedButton(
                    context, 'images/CheckPoint_LOGO.png', 'CheckPoint'),
                SizedBox(width: 5.0),
                // ViewMap Button
                _outLinedButton(context, 'images/ViewMap_LOGO.png', 'View Map'),
              ],
            ),
            SizedBox(height: 20.0),

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
                TextButton(
                  child: Text(
                    'See All',
                    style: TextStyle(color: rokkhiColor),
                  ),
                  onPressed: () {
                    // Show checkpoints list with bottomsheet
                    _checkpointsBottomSheet(context);
                  },
                ),
              ],
            ),
            Divider(
              thickness: 1.0,
              color: Colors.black,
            ),
            FutureBuilder<rt.Route>(
                future: loginRouteViewModel.fetchRoute(loginGuardViewModel.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (int i = 0;
                            i < snapshot.data.totalCheckpointNum;
                            i++)
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
            exitButton(context, 1),
          ],
        ),
      ),
    ),
  );
}

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
                              loginRouteViewModel.checkPoints[i].frequency),
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

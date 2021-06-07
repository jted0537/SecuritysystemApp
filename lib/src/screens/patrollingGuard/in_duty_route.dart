import 'package:flutter/material.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/main.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

Timer timer;
Timer locTimer;
int checkPoint = 0;

class InDutyRoute extends StatefulWidget {
  @override
  _InDutyRouteState createState() => _InDutyRouteState();
}

class _InDutyRouteState extends State<InDutyRoute> {
  int counter = 0;

  @override
  void initState() {
    super.initState();

    ////
    // 1.  Listen to events (See docs for all 12 available events).
    //

    // Fired whenever a location is recorded
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[location] - lat: ${location.coords.latitude} & lng: ${location.coords.longitude}');
    });

    // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    // bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
    //   print('[motionchange] - $location');
    // });

    // // Fired whenever the state of location-services changes.  Always fired at boot
    // bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
    //   print('[providerchange] - $event');
    // });

    ////
    // 2.  Configure the plugin
    //
    bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10.0,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: false,
        logLevel: bg.Config.LOG_LEVEL_OFF
    )).then((bg.State state) {
      if (!state.enabled) {
        ////
        // 3.  Start the plugin.
        //
        bg.BackgroundGeolocation.start();
      }
    });

    bg.BackgroundGeolocation.changePace(true);
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => alarmExpired());
  }

  @override
  void dispose() {

    timer?.cancel();
    super.dispose();
  }

  void alarmExpired() async {
    counter++;
    print("$counter: 10sec elapsed.");
    var location = await bg.BackgroundGeolocation.getCurrentPosition();
    print('[location] - lat: ${location.coords.latitude} & lng: ${location.coords.longitude}');
    //WebService().postGPSReply('patrol', '000000000009', 30.0, 60.0);
  }

  void alarmExpired2() async {
    
  }

  @override
  Widget build(BuildContext context) {
    // Using WillPopScope for block the return with device back button
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                    patrolLogo(loginGuardViewModel.guardName,
                        loginGuardViewModel.type),
                    // Widgets in cornerRadiusBox
                    _inCornerRadiusBox(context, formattedDate),
                    // RaisedButton(onPressed: ),
                  ],
                ),
              ),
            ],
          ),
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
      // TODO
      if(type != 'CheckPoint')
        Navigator.pushNamed(context, '/viewMap');
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
                _outLinedButton(context, 'images/CheckPoint_LOGO.png', 'CheckPoint'),
                SizedBox(width: 5.0),
                // ViewMap Button
                _outLinedButton(context, 'images/ViewMap_LOGO.png', 'View Map'),
              ],
            ),
            SizedBox(height: 20.0),

            //Checkpoints List
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
                  // 여기 왜 error나는지 확인 !!!
                  // formattedDate,
                  "2021-05-28",
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

            // TODO Add Route list
            // Column(
            //   children: [
            //     Text(RouteViewModel().loginRoute.routeTitle),
            //   ],
            // ),
            // EXIT button
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
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                child: Column(
                  children: [
                    topRightDismissButton(context),
                  ],
                ),
              ),
            ),
          ));
}

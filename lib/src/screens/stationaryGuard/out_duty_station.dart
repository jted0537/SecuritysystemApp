import 'package:flutter/material.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/src/components/dialogs.dart';
import 'package:security_system/src/components/dashed_rect.dart';
import 'package:security_system/main.dart';
import 'package:security_system/src/models/station.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:security_system/src/services/local_notification.dart';

class OutDutyStation extends StatefulWidget {
  @override
  _OutDutyStationState createState() => _OutDutyStationState();
}

class _OutDutyStationState extends State<OutDutyStation> {
  bool isDutyTime;
  LocalNotification localNotification = LocalNotification();

  // Check if work is done
  void checkEndWork() async {
    now = DateTime.now();
    print('alarm go!');
    if (loginGuardViewModel.endTimeHour * 60 +
            loginGuardViewModel.endTimeMinute <=
        now.hour * 60 + now.minute) {
      print('alarm done');
      await currentWorkViewModel.endWork(currentWorkViewModel.workID);
      localNotification.cancelAllNotification();
      timer.cancel();
      setState(() {
        this.isDutyTime = false;
        currentWorkViewModel.currentWork = null;
        loginGuardViewModel.loginGuard.status = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);
    formattedDate = DateFormat('dd.MM.yyyy').format(now);
    // Calculate current time for start work (Enable to access work +/- 3 minute)
    if (now.hour * 60 + now.minute <=
            loginGuardViewModel.endTimeHour * 60 +
                loginGuardViewModel.endTimeMinute +
                3 &&
        now.hour * 60 + now.minute >=
            loginGuardViewModel.startTimeHour * 60 +
                loginGuardViewModel.startTimeMinute -
                3)
      this.isDutyTime = true;
    else
      this.isDutyTime = false;
    // Start timer
    timer = Timer.periodic(Duration(seconds: 180), (Timer t) => checkEndWork());
    localNotification.initialSettings();
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
                  // Appointed Station
                  FutureBuilder<Station>(
                    future: loginStationViewModel
                        .fetchStation(loginGuardViewModel.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
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
                                Text('Appointed Station',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.0,
                                      fontWeight: titleFontWeight,
                                    )),
                                SizedBox(height: 10.0),
                                Text(
                                  snapshot.data.stationTitle,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: defaultFontWeight,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(rokkhiColor),
                      );
                    },
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
                        navigation: '/inDutyStation',
                        localNotification: this.localNotification,
                      )),
                  SizedBox(height: 20.0),
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

class DutyTimeWidget extends StatefulWidget {
  final bool isDutyTime;
  final String navigation;
  final LocalNotification localNotification;

  DutyTimeWidget(this.isDutyTime, this.navigation, this.localNotification);

  @override
  _DutyTimeWidgetState createState() => _DutyTimeWidgetState();
}

class _DutyTimeWidgetState extends State<DutyTimeWidget> {
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
                ? 'You have your work'
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

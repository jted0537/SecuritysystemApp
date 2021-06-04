import 'package:flutter/material.dart';
import 'dart:async';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/main.dart';
import 'package:intl/intl.dart';
import 'package:security_system/src/models/station.dart';

class OutDutyStation extends StatefulWidget {
  @override
  _OutDutyStationState createState() => _OutDutyStationState();
}

class _OutDutyStationState extends State<OutDutyStation> {
  bool isDutyTime;

  // Check if work is done
  void alarmExpired() async {
    now = DateTime.now();
    print('alarm go!');
    if (loginGuardViewModel.endTimeHour * 60 +
            loginGuardViewModel.endTimeMinute <=
        now.hour * 60 + now.minute) {
      print('alarm done');
      await currentWorkViewModel.endWork(currentWorkViewModel.workID);
      timer.cancel();
      setState(() {
        this.isDutyTime = false;
        currentWorkViewModel.currentWork = null;
        loginGuardViewModel.loginGuard.status = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);
    formattedDate = DateFormat('dd.MM.yyyy').format(now);
    // Calculate current time for start work
    if (now.hour * 60 + now.minute <=
            loginGuardViewModel.endTimeHour * 60 +
                loginGuardViewModel.endTimeMinute &&
        now.hour * 60 + now.minute >=
            loginGuardViewModel.startTimeHour * 60 +
                loginGuardViewModel.startTimeMinute)
      this.isDutyTime = true;
    else
      this.isDutyTime = false;
    // Start timer
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => alarmExpired());
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

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:security_system/src/components/dashed_rect.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/main.dart';

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
    // calculate the current date & time
    now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);
    formattedDate = DateFormat('dd.MM.yyyy').format(now);
    // check if current time is working time
    if (now.hour * 60 + now.minute <=
            loginGuardViewModel.endTimeHour * 60 +
                loginGuardViewModel.endTimeMinute &&
        now.hour * 60 + now.minute >=
            loginGuardViewModel.startTimeHour * 60 +
                loginGuardViewModel.startTimeMinute -
                10)
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
                  FutureBuilder(
                    future:
                        loginRouteViewModel.fetchRoute(loginGuardViewModel.id),
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
                                Text('Appointed Route',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.0,
                                      fontWeight: titleFontWeight,
                                    )),
                                SizedBox(height: 10.0),
                                Text(
                                  snapshot.data.routeTitle,
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
                          navigation: '/inDutyRoute',
                          type: 'patrol')),
                  SizedBox(height: 20.0),
                  // EXIT Button(Back to login screen)
                  OutlinedButton(
                      style: buttonStyle(Colors.grey, Colors.white),
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text('Logout & Stop location tracking')),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        timer.cancel();
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

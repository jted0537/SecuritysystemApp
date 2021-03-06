import 'package:flutter/material.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/src/components/dialogs.dart';
import 'package:security_system/main.dart';
import 'package:security_system/src/services/web_service.dart';
import 'package:security_system/src/services/local_auth_service.dart';
import 'package:security_system/src/models/work.dart';
import 'package:intl/intl.dart';

class InDutyStation extends StatefulWidget {
  @override
  _InDutyStationState createState() => _InDutyStationState();
}

class _InDutyStationState extends State<InDutyStation> {
  // Doing authentication for attendance
  Future<void> authentication() async {
    final isAuthenticated = await LocalAuthService.authenticate();

    if (isAuthenticated == BioMetricLogin.Success) {
      // If Biometric authentication success
      await WebService().stationaryResponse(currentWorkViewModel.workID);
      setState(() {});
    } else if (isAuthenticated == BioMetricLogin.NoBioMetricInfo) {
      // If device has no biometric authentication information, alert message pop
      noBioMetricInfoDialog(context);
    } else if (isAuthenticated == BioMetricLogin.DeviceNotProvide) {
      // If device has no biometric auth function
      notProvideBioMetricDialog(context);
    }
  }

  // Using global botton app button for attendance
  Widget bottomAttendanceButton() {
    return BottomAppBar(
      elevation: 15.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: OutlinedButton(
          style: buttonStyle(Colors.white, rokkhiColor),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 13.0),
            child: Text('Attendance'),
          ),
          onPressed: () async {
            await authentication();
          },
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    // Calculate current time
    now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);
    formattedDate = DateFormat('dd.MM.yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    // Using WillPopScope for block the return with device back button
    return Scaffold(
      backgroundColor: Colors.grey[150],
      bottomNavigationBar: bottomAttendanceButton(),
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
                  InCornerRadiusBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InCornerRadiusBox extends StatefulWidget {
  @override
  _InCornerRadiusBoxState createState() => _InCornerRadiusBoxState();
}

// Stateful widget in corner radius box
class _InCornerRadiusBoxState extends State<InCornerRadiusBox> {
  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 5.0),
              Column(
                children: [
                  // Appointed Route
                  SizedBox(height: 10.0),
                  Image.asset('images/marker.png', height: 25.0, width: 25.0),
                  SizedBox(height: 10.0),
                  Text('Appointed Station',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: titleFontWeight,
                      )),
                  // Station title
                  Text(
                    loginStationViewModel.stationTitle,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: defaultFontWeight,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(height: 20.0),

                  // Station Address
                  Text('Address',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: titleFontWeight,
                      )),
                  SizedBox(height: 5.0),
                  Text(
                    loginStationViewModel.stationAddress,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: defaultFontWeight,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.0),

              // Latest Attendance list
              Column(
                children: [
                  Row(
                    children: [
                      Text('Latest Attendance',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      Spacer(),
                      TextButton(
                        child: Text(
                          'See All',
                          style: TextStyle(color: rokkhiColor),
                        ),
                        onPressed: () {
                          // Show checkpoints list with bottomsheet
                          _attendanceBottomSheet(context);
                        },
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1.0,
                    color: Colors.black,
                  ),
                  // Station working list with attendance information
                  FutureBuilder<Work>(
                    future:
                        currentWorkViewModel.getWork(loginGuardViewModel.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          // List of station works
                          children: [
                            for (int i = 0;
                                i < snapshot.data.alarmTimeList.length;
                                i++)
                              Column(
                                children: [
                                  _attendance(snapshot.data.alarmTimeList[i],
                                      snapshot.data.responseCntList[i]),
                                  Divider(
                                    thickness: 1.0,
                                  ),
                                ],
                              ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        // If data fetch failed
                        return Text('${snapshot.error}');
                      }
                      return CircularProgressIndicator(
                        // While fetching data from server
                        valueColor: AlwaysStoppedAnimation<Color>(rokkhiColor),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              // EXIT button
              exitButton(context, 1),
            ],
          ),
        ),
      ),
    );
  }
}

// Bottom sheet for attendance list(when touch 'See all' button)
void _attendanceBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
    ),
    isScrollControlled: true,
    builder: (context) => Container(
      height: 400.0,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            topRightDismissButton(context),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Latest Attendance',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.black,
            ),
            for (int i = 0; i < currentWorkViewModel.alarmTimeList.length; i++)
              Column(
                children: [
                  _attendance(currentWorkViewModel.alarmTimeList[i],
                      currentWorkViewModel.responseCntList[i]),
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
  );
}

// For each row of station works information
Widget _attendance(String time, int isComplete) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(dateParse(time),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )),
          Text(
            formattedDate,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13.0,
            ),
          ),
        ]),
        Image.asset(
          isComplete == 1
              ? 'images/complete_LOGO.png'
              : 'images/notComplete_LOGO.png',
          width: 45.0,
        ),
      ],
    ),
  );
}

// Parsing date string to AM/PM type
String dateParse(String time) {
  int hour = int.parse(time.split(":")[0]);
  int minute = int.parse(time.split(":")[1]);
  String realTime = '';

  if (hour >= 12) {
    if (hour > 12) hour -= 12;

    realTime += hour > 9 ? '$hour:' : '0$hour:';
    realTime += minute > 9 ? '$minute pm' : '0$minute pm';
  } else {
    realTime += hour > 9 ? '$hour:' : '0$hour:';
    realTime += minute > 9 ? '$minute am' : '0$minute am';
  }

  return realTime;
}

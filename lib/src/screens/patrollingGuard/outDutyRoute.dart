import 'package:flutter/material.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:intl/intl.dart';
import 'package:security_system/main.dart';

// AppointedRouteMenu
class OutDutyRoute extends StatefulWidget {
  @override
  _OutDutyRouteState createState() => _OutDutyRouteState();
}

class _OutDutyRouteState extends State<OutDutyRoute> {
  DateTime now;
  DateTime date;
  String formattedDate;
  bool isDutyTime;

  // It is Duty time or not
  Widget _dutyTimeWidget(bool isDutyTime) {
    if (!isDutyTime)
      return Text(
        'Not Assigned Yet',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: defaultFontWeight,
          decoration: TextDecoration.underline,
        ),
      );
    else
      return Text(
        'This is your duty time',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: defaultFontWeight,
          decoration: TextDecoration.underline,
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    // Calculate current time
    now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);
    formattedDate = DateFormat('dd.MM.yyyy').format(now);
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
                    child: OutlinedButton(
                      child: Column(
                        children: [
                          Image.asset('images/marker/marker.png',
                              height: 25.0, width: 25.0),
                          SizedBox(height: 5.0),
                          Text('Appointed Route',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.0,
                                fontWeight: titleFontWeight,
                              )),
                          SizedBox(height: 5.0),
                          _dutyTimeWidget(this.isDutyTime),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/inDutyRoute');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
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
                      )),
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
                          routeModalBottomSheet(context);
                        },
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1.0,
                    color: Colors.black,
                  ),

                  // EXIT Button
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

// Bottom sheet for Appointed route
void routeModalBottomSheet(BuildContext context) {
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

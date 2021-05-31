import 'package:flutter/material.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/main.dart';
import 'package:security_system/src/viewmodels/station_view_model.dart';
import 'package:security_system/src/models/work.dart';
import 'package:security_system/src/models/station.dart';
import 'package:intl/intl.dart';

class InDutyStation extends StatefulWidget {
  @override
  _InDutyStationState createState() => _InDutyStationState();
}

class _InDutyStationState extends State<InDutyStation> {
  @override
  initState() {
    super.initState();
    now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);
    formattedDate = DateFormat('dd.MM.yyyy').format(now);
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
                  _inCornerRadiusBox(context),
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
Widget _inCornerRadiusBox(BuildContext context) {
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
                FutureBuilder<Work>(
                  future: currentWorkViewModel.fetchWork(loginId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          for (int i = 0;
                              i < snapshot.data.alarmTimeList.length;
                              i++)
                            Column(
                              children: [
                                _attendance(
                                    snapshot.data.alarmTimeList[i],
                                    snapshot.data.responseCntList[i] == 1
                                        ? true
                                        : false),
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
                  _attendance(
                      currentWorkViewModel.alarmTimeList[i],
                      currentWorkViewModel.responseCntList[i] == 0
                          ? false
                          : true),
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

// For each attendance
Widget _attendance(String time, bool isComplete) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
<<<<<<< HEAD
        Column(
          children: [
            Text(time,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                )),
            Text(
              //formattedDate,
              '2021-05-29',
=======
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(time,
>>>>>>> a5faf5357ae72356725149f249a73361562c7918
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
          isComplete
              ? 'images/complete_LOGO.png'
              : 'images/notComplete_LOGO.png',
          width: 45.0,
        ),
      ],
    ),
  );
}

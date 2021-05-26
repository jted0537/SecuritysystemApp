import 'package:flutter/material.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/main.dart';

class InDutyStation extends StatefulWidget {
  @override
  _InDutyStationState createState() => _InDutyStationState();
}

class _InDutyStationState extends State<InDutyStation> {
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
                    _inCornerRadiusBox(context),
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
            SizedBox(height: 5.0),
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
            Text(
              loginStationViewModel.stationAddress,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: defaultFontWeight,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 20.0),

            // Latest Attendance list
            _latestAttendance(context, true),
            // EXIT button
            exitButton(context, 2),
          ],
        ),
      ),
    ),
  );
}

// Widget for Latest Attendance list(with or not See all button)
Widget _latestAttendance(BuildContext context, bool saButton) {
  return Column(
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
                    builder: (context) => SingleChildScrollView(
                          child: Container(
                            height: 400.0,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  topRightDismissButton(context),
                                  _latestAttendance(context, false),
                                ],
                              ),
                            ),
                          ),
                        ));
              },
            ),
        ],
      ),
      Divider(
        thickness: 1.0,
        color: Colors.black,
      ),
      for (int i = 0; i < loginGuardViewModel.workCount; i++)
        Column(
          children: [
            _temp(' 12:12 am', i % 2 == 0),
            Divider(
              thickness: 1.0,
            ),
          ],
        ),
    ],
  );
}

// For each attendance
Widget _temp(String time, bool isComplete) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Column(
          children: [
            Text(time,
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
          ],
        ),
        Spacer(),
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

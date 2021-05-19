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
              // Appointed Route Widget
              SizedBox(
                height: 10.0,
              ),
              Image.asset('images/marker.png', height: 25.0, width: 25.0),
              SizedBox(
                height: 10.0,
              ),
              Text('Appointed Station',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: titleFontWeight,
                  )),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'This is your duty time',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: defaultFontWeight,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(
                height: 25.0,
              ),

              // Latest Attendance List
              Row(
                children: [
                  Text('Latest Attendance',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      )),
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
              // EXIT button
              exitButton(context, 2),
            ],
          ),
        ),
      ),
    );
  }
}

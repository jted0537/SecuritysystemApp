import 'package:flutter/material.dart';
import 'package:security_system/components/preferences.dart';

class InDutyRoute extends StatefulWidget {
  @override
  _InDutyRouteState createState() => _InDutyRouteState();
}

class _InDutyRouteState extends State<InDutyRoute> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[150],
      body: SafeArea(
        child: Column(
          children: [
            // For Company Logo Images
            patrolLogo(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
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
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Text('1'),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

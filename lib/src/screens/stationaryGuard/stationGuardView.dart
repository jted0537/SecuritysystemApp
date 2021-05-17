import 'package:flutter/material.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/main.dart';
import 'package:security_system/src/viewmodels/GuardViewModel.dart';

class StationGuardView extends StatefulWidget {
  @override
  _StationGuardViewState createState() => _StationGuardViewState();
}

class _StationGuardViewState extends State<StationGuardView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[150],
      body: SafeArea(
        child: Column(
          children: [
            // For Company Logo Images
            patrolLogo(loginGuardViewModel.guardName, loginGuardViewModel.type),
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

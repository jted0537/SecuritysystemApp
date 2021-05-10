import 'package:flutter/material.dart';
import 'package:security_system/extensions/preferences.dart';

class AppointedRoute extends StatefulWidget {
  @override
  _AppointedRouteState createState() => _AppointedRouteState();
}

class _AppointedRouteState extends State<AppointedRoute> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      // appBar: AppBar(
      //   backgroundColor: Colors.grey[200],
      //   title: Text('11'),
      //   elevation: 0.0,
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Text('11'),
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

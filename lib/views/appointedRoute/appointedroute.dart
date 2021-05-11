import 'package:flutter/material.dart';
import 'package:security_system/components/preferences.dart';

class AppointedRoute extends StatefulWidget {
  @override
  _AppointedRouteState createState() => _AppointedRouteState();
}

class _AppointedRouteState extends State<AppointedRoute> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[150],
      // appBar: AppBar(
      //   backgroundColor: Colors.grey[200],
      //   title: Text('11'),
      //   elevation: 0.0,
      // ),
      body: SafeArea(
        child: Column(
          children: [
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

Widget patrolLogo() {
  return Padding(
    padding: EdgeInsets.all(15.0),
    child: Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              'images/Rokkhi_LOGO.png',
              height: 40,
              width: 70,
            )),
        Row(
          children: [
            Image.asset(
              'images/ShahidulBari_LOGO.png',
              height: 40,
            ),
            Spacer(),
            Image.asset(
              'images/Patrol_LOGO.png',
              height: 150,
            ),
          ],
        ),
      ],
    ),
  );
}

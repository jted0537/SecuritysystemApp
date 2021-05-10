import 'package:flutter/material.dart';

class AppointedRoute extends StatefulWidget {
  @override
  _AppointedRouteState createState() => _AppointedRouteState();
}

class _AppointedRouteState extends State<AppointedRoute> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      //color: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(40.0),
                //topRight: const Radius.circular(40.0),
              )),
          child: Center(
            child: Text("Hi modal sheet"),
          )),
    );
  }
}

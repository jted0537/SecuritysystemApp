import 'package:flutter/material.dart';
import 'package:security_system/preferences.dart';

class RouteList extends StatefulWidget {
  @override
  _RouteListState createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   leading: shahidulLogoImage(),
        //   toolbarHeight: 100.0,
        //   elevation: 0.0,
        // ),
        body: logoAppBar(),
      ),
    );
  }
}

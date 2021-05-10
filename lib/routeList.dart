import 'package:flutter/material.dart';
import 'package:security_system/preferences.dart';
import 'package:dio/dio.dart';

class RouteList extends StatefulWidget {
  @override
  _RouteListState createState() => _RouteListState();
}

void getHttp() async {
  try {
    var response = await Dio().get('https://www.google.com/');
    print(response);
  } catch (e) {
    print(e);
  }
}

class _RouteListState extends State<RouteList> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            logoAppBar(),
            Text('place'),
            OutlinedButton(
                style: buttonStyle(Colors.grey, Colors.white),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text('EXIT')),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: Text("11111"),
              onPressed: () {
                //getHttp();
                Navigator.pushNamed(context, '/ad');
              },
            ),
          ],
        ),
      ),
    );
  }
}

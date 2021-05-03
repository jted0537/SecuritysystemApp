import 'package:flutter/material.dart';

class GuardManage extends StatefulWidget {
  @override
  _GuardManageState createState() => _GuardManageState();
}

class _GuardManageState extends State<GuardManage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("data"),
          leading: IconButton(
            icon: Icon(Icons.ac_unit),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Text('Hello'),
      ),
    );
  }
}

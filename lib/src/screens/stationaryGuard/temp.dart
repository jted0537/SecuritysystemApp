import 'package:flutter/material.dart';

class TempWidget extends StatefulWidget {
  @override
  _TempWidgetState createState() => _TempWidgetState();
}

class _TempWidgetState extends State<TempWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: TextButton(
          child: Text('push me!'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

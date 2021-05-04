import 'package:flutter/material.dart';

//------------------------------------------------Widget--------------------------------------------------------------
// Widget For Logo Image
Widget logoImage() {
  return Padding(
    padding: const EdgeInsets.only(top: 100.0, bottom: 100.0),
    child: Center(
      child: Container(
          width: 200,
          height: 150,
          child: Image.asset('images/Rokkhi_LOGO.png')),
    ),
  );
}

//------------------------------------------------Style--------------------------------------------------------------
// Textfield UI Design
InputDecoration textfeildDesign() {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: rokkhiColor, width: 0.4),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 0.4),
    ),
    hintText: '0172345678',
  );
}

// Button UI Design
ButtonStyle buttonStyle(Color foregroundColor, Color backgroundColor) {
  return OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0))),
    primary: foregroundColor,
    backgroundColor: backgroundColor,
  );
}

//------------------------------------------------Design--------------------------------------------------------------
FontWeight defalutFont = FontWeight.w400;
Color rokkhiColor = Colors.red;

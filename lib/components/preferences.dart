import 'package:flutter/material.dart';

//------------------------------------------------Widget--------------------------------------------------------------
// Widget For Rokkhi LOGO
Widget rokkhiLogoImage() {
  return Padding(
    padding: const EdgeInsets.only(top: 90.0, bottom: 140.0),
    child: Center(
      child: Image.asset('images/Rokkhi_LOGO.png'),
    ),
  );
}

// Widget For Shahidul LOGO
Widget shahidulLogoImage() {
  return Image.asset('images/ShahidulBari_LOGO.png');
}

// Widget For Custom Appbar
Widget logoAppBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Image.asset(
        'images/ShahidulBari_LOGO.png',
        height: 80,
        width: 100,
      ),
      Image.asset(
        'images/Rokkhi_LOGO.png',
        height: 80,
        width: 60,
      ),
    ],
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
        borderRadius: BorderRadius.all(Radius.circular(4.0))),
    primary: foregroundColor,
    backgroundColor: backgroundColor,
  );
}

//------------------------------------------------Design--------------------------------------------------------------
FontWeight defaultFontWeight = FontWeight.w400;
Color rokkhiColor = Colors.red;

import 'package:flutter/material.dart';

//------------------------------------------------Widget
// Widget For Rokkhi LOGO
Widget rokkhiLogoImage() {
  return Padding(
    padding: const EdgeInsets.only(top: 90.0, bottom: 130.0),
    child: Center(
      child: Image.asset(
        'images/Rokkhi_LOGO.png',
        height: 70.0,
        width: 110.0,
      ),
    ),
  );
}

// Widget For Custom Appbar
Widget logoAppBar(String guardName, String type) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Image.asset(
            'images/Shield_LOGO.png',
            height: 25,
            width: 25,
          ),
          SizedBox(
            width: 5.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                guardName,
                style: TextStyle(fontWeight: titleFontWeight),
              ),
              if (type == 'patrol')
                Text('Patrolling Guard',
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: defaultFontWeight,
                        color: Colors.grey))
              else
                Text('Stationary Guard',
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: defaultFontWeight,
                        color: Colors.grey)),
            ],
          ),
        ],
      ),
      Image.asset(
        'images/Rokkhi_LOGO.png',
        //height: 90,
        width: 70,
      ),
    ],
  );
}

// Widget for patrol logo (Rokkhi, Guard (name,type), Patrol image)
Widget patrolLogo(String guardName, String type) {
  return Padding(
    padding: EdgeInsets.fromLTRB(15.0, 10.0, 30.0, 0.0),
    child: Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              'images/Rokkhi_LOGO.png',
              height: 50,
              width: 80,
            )),
        Row(
          children: [
            Image.asset(
              'images/Shield_LOGO.png',
              height: 35,
              width: 35,
            ),
            SizedBox(
              width: 5.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(guardName,
                    style: TextStyle(
                      fontWeight: titleFontWeight,
                      fontSize: 17.0,
                    )),
                if (type == 'patrol')
                  Text('Patrolling Guard',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: defaultFontWeight,
                          color: Colors.grey))
                else
                  Text('Stationary Guard',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: defaultFontWeight,
                          color: Colors.grey)),
              ],
            ),
            Spacer(),
            Image.asset(
              'images/Patrol_LOGO.png',
              width: 140,
            ),
          ],
        ),
      ],
    ),
  );
}

// Widget For Patrol View Map
Widget viewMapLogo(String guardName, String type) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          SizedBox(
            width: 10.0,
          ),
          Image.asset(
            'images/Shield_LOGO.png',
            height: 40,
            width: 40,
          ),
          SizedBox(
            width: 5.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                guardName,
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: titleFontWeight,
                  color: Colors.grey[900]),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// Widget for topRight dismiss button
Widget topRightDismissButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 40.0,
        child: TextButton(
          child: Image.asset(
            'images/Dismiss_LOGO.png',
            width: 22.0,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    ],
  );
}


// Widget for exit button, It will pop navigate (count) times
Widget exitButton(BuildContext context, int count) {
  // EXIT Button
  return OutlinedButton(
      style: buttonStyle(Colors.grey, Colors.white),
      child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0), child: Text('EXIT')),
      onPressed: () {
        for (var a = 0; a < count; a++) {
          Navigator.of(context).pop();
        }
      });
}

//------------------------------------------------Style
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

//------------------------------------------------Design
FontWeight titleFontWeight = FontWeight.bold;
FontWeight defaultFontWeight = FontWeight.w400;
Color rokkhiColor = Color(0xffff3300);

import 'package:flutter/material.dart';
import 'package:security_system/components/preferences.dart';
import 'package:intl/intl.dart';

// AppointedRouteMenu
class OutDutyRoute extends StatefulWidget {
  @override
  _OutDutyRouteState createState() => _OutDutyRouteState();
}

class _OutDutyRouteState extends State<OutDutyRoute> {
  DateTime now;
  DateTime date;
  String formattedDate;
  bool isDutyTime;

  // It is Duty time or not
  Widget _dutyTimeWidget(bool isDutyTime) {
    if (!isDutyTime)
      return Text(
        'Not Assigned Yet',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: defaultFontWeight,
          decoration: TextDecoration.underline,
        ),
      );
    else
      return Text(
        'This is your duty time',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: defaultFontWeight,
          decoration: TextDecoration.underline,
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);
    formattedDate = DateFormat('dd/MM/yyyy').format(now);
    this.isDutyTime = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              logoAppBar(),
              // Appointed Route Button
              Container(
                width: double.infinity,
                child: OutlinedButton(
                  // For 'Submit your fingerprint button
                  child: Column(
                    children: [
                      Image.asset('images/marker.png',
                          height: 25.0, width: 25.0),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text('Appointed Route',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w700,
                          )),
                      SizedBox(
                        height: 5.0,
                      ),
                      _dutyTimeWidget(this.isDutyTime),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/ad');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                  width: double.infinity,
                  color: Colors.black12,
                  child: DashedRect(
                    color: Colors.grey[300],
                    strokeWidth: 2.0,
                    gap: 3.0,
                    isDutyTime: this.isDutyTime,
                  )),
              SizedBox(
                height: 20.0,
              ),
              // Checkpoints
              Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Text('Checkpoints',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13.0,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      child: Text(
                        'See All',
                        style: TextStyle(color: rokkhiColor),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 0.6,
                color: Colors.black,
              ),

              // EXIT Button
              OutlinedButton(
                  style: buttonStyle(Colors.grey, Colors.white),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text('EXIT')),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
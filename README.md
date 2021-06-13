# Rokkhi Limited
## COMPUTER VISION GUARD MANAGEMENT(CVGM)

------------------------------------------
Flutter Guard Management Application for Stationary Guard and Patrolling Guard. </br>
Using Rest API, Google Maps, etc. </br>


## Getting Started

Before add packages, you should make API_KEY for Google map first.

You can do this task at [Google cloud platform](https://console.cloud.google.com/)

After make your own project at platform, Choose API & Service Menu</br>,
and choose "Maps SDK for Android" or "Maps SDK for ios"

Alright! now you can add google map packages & geoloactor to your own project!

## How to Use 

1. Using packages(Specified version)
~~~yaml
dependencies:
  flutter:
    sdk: flutter
  intl_phone_number_input: ^0.7.0+1
  local_auth: ^1.1.5
  intl: ^0.17.0
  cupertino_icons: ^1.0.2
  flutter_local_notifications: ^6.0.0
  http: ^0.13.3
  connectivity: ^3.0.4
  shared_preferences: ^2.0.5
  battery: ^2.0.3
  google_maps_flutter: ^2.0.5
  flutter_background_geolocation: ^1.9.0
  location: ^4.1.1
  location_permissions: ^4.0.0
~~~
</br>

2. Dependencies (At android/app/src/main/AndroidManifest.xml above activity)
~~~xml
 <meta-data
      android:name="com.google.android.geo.API_KEY"
      android:value="{Your Google Map API_KEY from Google Cloud Platform}"
      /> 
~~~
</br>

3. install (At terminal)
~~~Linux
flutter pub get
~~~
or save file at your IDE. (It will automatically install it)
</br>


### Libraries & Tools Used
* [intl_phone_number_input](https://pub.dev/packages/intl_phone_number_input)
* [local_auth](https://pub.dev/packages/local_auth)
* [intl](https://pub.dev/packages/intl)
* [cupertino_icons](https://pub.dev/packages/cupertino_icons)
* [flutter_local_notifications ](https://pub.dev/packages/flutter_local_notifications)
* [http](https://pub.dev/packages/http)
* [connectivity](https://pub.dev/packages/connectivity)
* [shared_preferences](https://pub.dev/packages/shared_preferences)
* [battery](https://pub.dev/packages/battery)
* [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)
* [flutter_background_geolocation](https://pub.dev/packages/flutter_background_geolocation)
* [location](https://pub.dev/packages/location)
* [location_permissions](https://pub.dev/packages/location_permissions)

### Folder Structure
Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- build
|- images
|- ios
|- lib
```

Here is the folder structure we have been using in this project

```
lib/
|- src
    |- components/
    |- models/
    |- screens/
    |- services/
    |- viewmodels/
|- main.dart/
```

Now, lets dive into the lib folder which has the main code for the application.

```
1- components - Directory for frequently used Widget, Dialogs, Fonts etc.
2- models - Model class for store data. (Guard, Route, Station etc)
3- screens - All of screens(UI) is in here.
4- services - Functions, services like local_notification, local_authentication.
5- viemodels - Viewmodels for models. All of using data functions are in here.
8- main.dart - This is the starting point of the application. 
All the navigations and viewmodels are defined in this file .
```

### components

This directory contains a frequently used Widget, Dialogs, Fonts etc.

```
components/
|- dashed_rect.dart
|- dialogs.dart
|- preferences.dart
```

### models, viewmodels

All the business logic of application will go into this directory, it represents the data layer of application. Since each layer exists independently, that makes it easier to unit test. 
```
models/
|- checkpoint.dart
|- guard.dart
|- route.dart
|- station.dart
|- work.dart
   
view_models/
|- guard_view_model.dart
|- route_view_model.dart
|- station_view_model.dart
|- work_view_model.dart

```

### screens

This directory contains all the UI of application. Each screen is located in a separate folder making it easy to combine group of files related to that particular screen. 

```
screens/
|- login
   |- login_view.dart
   |- local_auth_view.dart
|- patrollingGuard
   |- in_duty_route.dart
   |- out_duty_route.dart
   |- view_map.dart
|- stationaryGuard
   |- in_duty_station.dart
   |- out_duty_station.dart

```

### services

Contains the functions, services for REST API, Local authentication, Local Notification.

```
services/
|- local_auth_service.dart
|- local_notification_service.dart
|- web_service.dart
```

### Main

This is the starting point of the application. All the navigations and viewmodels are defined in this file.

```dart
import 'package:flutter/material.dart';
import 'package:security_system/src/screens/login/login_view.dart';
import 'package:security_system/src/screens/login/local_auth_view.dart';
import 'package:security_system/src/screens/patrollingGuard/in_duty_route.dart';
import 'package:security_system/src/screens/patrollingGuard/out_duty_route.dart';
import 'package:security_system/src/screens/patrollingGuard/viewMap.dart';
import 'package:security_system/src/screens/stationaryGuard/in_duty_station.dart';
import 'package:security_system/src/screens/stationaryGuard/out_duty_station.dart';
import 'package:security_system/src/viewmodels/guard_view_model.dart';
import 'package:security_system/src/viewmodels/route_view_model.dart';
import 'package:security_system/src/viewmodels/station_view_model.dart';
import 'package:security_system/src/viewmodels/work_view_model.dart';
import 'dart:async';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:battery/battery.dart';

final loginGuardViewModel = GuardViewModel();
final loginRouteViewModel = RouteViewModel();
final loginStationViewModel = StationViewModel();
final currentWorkViewModel = WorkViewModel();
DateTime now;
DateTime date;
String formattedDate;
PhoneNumber loginNumber = PhoneNumber(isoCode: 'BD');
Timer timer;
var battery = Battery();
// Application Entry Point
void main() async => runApp(SecureApp());

class SecureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // For Navigator
        '/': (context) => LoginScreen(),
        '/localAuth': (context) => LocalAuth(),
        '/inDutyRoute': (context) => InDutyRoute(),
        '/outDutyRoute': (context) => OutDutyRoute(),
        '/inDutyStation': (context) => InDutyStation(),
        '/outDutyStation': (context) => OutDutyStation(),
        '/viewMap': (context) => ViewMap(),
      },
      title: 'Rokkhi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      //home: LoginScreen(),
    );
  }
}
```

## Wiki

Checkout [Sogang wiki](http://cscp2.sogang.ac.kr/CSE4186/index.php/Rokkhi_Limited_(IoT%EB%A5%BC_%EC%9D%B4%EC%9A%A9%ED%95%9C_%EC%8B%9C%EC%84%A4%EA%B4%80%EB%A6%AC%EC%8B%9C%EC%8A%A4%ED%85%9C)) for more info about this project


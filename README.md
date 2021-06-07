# security_system
------------------------------------------
Flutter Guard Management Application. </br>
For Stationary Guard and Patrolling Guard. </br>
Using Rest API, Google Maps. </br>

## Getting Started
-------------------------------------------
Before add packages, you should make API_KEY for Google map first.

You can do this task at [Google cloud platform](https://console.cloud.google.com/)

After make your own project at platform, Choose API & Service Menu</br>,
and choose "Maps SDK for Android" or "Maps SDK for ios"

Alright! now you can start "add google map packages & geoloactor" to your own project!

### Android

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
~~~
</br>

2. Dependencies (At android/app/src/main/AndroidManifest.xml above activity)
~~~xml
 <meta-data
      android:name="com.google.android.geo.API_KEY"
      android:value="{Your Google Map API_KEY from Google Cloud Platform"
      /> 
~~~
</br>

3. install (At terminal)
~~~Linux
flutter pub get
~~~
or save file at your IDE. (It will automatically install it)
</br>
</br>

4. Permission(At AndroidManifest.xml above application)
~~~xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
    <uses-permission android:name="android.permission.USE_FINGERPRINT"/>
~~~
</br>
</br>

 ### IOS(Developing...)

</br>
</br>


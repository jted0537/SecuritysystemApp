# security_system
------------------------------------------
Google Map API_KEY와 geolocator를 이용하여 현재 사용자의 위치를
Google Map에 표시해준다.

## Getting Started
-------------------------------------------
Before add packages, you should make API_KEY for Google map first.

You can do this task at [Google cloude platform](https://console.cloud.google.com/)

After make your own project at platform, Choose API & Service Menu</br>,
and choose "Maps SDK for Android" or "Maps SDK for ios"

Alright! now you can start add google map packages to your own project!

### Android

1. Add packages at pubspec.yaml
~~~yaml
dependencies:
  geolocator: ^7.0.1
  google_maps_flutter: ^2.0.2
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
~~~
flutter pub get
~~~
or save file at your IDE. (It will automatically install it)
</br>
</br>

 ### IOS
 1. Add packages at pubspec.yaml
~~~yaml
dependencies:
  geolocator: ^7.0.1
  google_maps_flutter: ^2.0.2
~~~
</br>

2. Dependencies(At ios/Runner/AppDelegate.swift above GeneratedPluginRegistrant.register(with: self))
~~~Swift
GMSServices.provideAPIKEY("{Your Google Map API_KEY from Google Cloud Platform}")
~~~
</br>

3. install (At terminal)
~~~
flutter pub get
~~~
or save file at your IDE. (It will automatically install it)
</br>
</br>

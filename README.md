# security_system
------------------------------------------
Google Map API_KEY와 geolocator를 이용하여 현재 사용자의 위치를
Google Map에 표시해준다.

## Getting Started
-------------------------------------------
Before add packages, you should make API_KEY for Google map first.

You can do this task at https://console.cloud.google.com/

After make your own project at platform, Choose API & Service Menu</br>
and choose "Maps SDK for Android" or "Maps SDK for ios"

Alright! then you can start add google map packages to your own project!

### Android

1. Add packages at pubspec.yaml
<pre>
<code>
dependencies:
  geolocator: ^7.0.1
  google_maps_flutter: ^2.0.2
</code>
</pre>
</br>
2. Dependencies(At android/app/src/main/AndroidManifest.xml above activity)
<pre>
<code>
 <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="{Your Google Map API_KEY from Google Cloud Platform"
            /> <!-- for google map API_KEY-->
</code>
</pre>
</br>
3. install
<pre>
<code>
flutter pub get
</code>
</pre>
 or just CMD+s at VSCode
</br>
</br>

 ### IOS
 1. Add packages at pubspec.yaml
<pre>
<code>
dependencies:
  geolocator: ^7.0.1
  google_maps_flutter: ^2.0.2
</code>
</pre>
</br>
2. Dependencies(At ios/Runner/AppDelegate.swift above GeneratedPluginRegistrant.register(with: self))
<pre>
<code>
    GMSServices.provideAPIKEY("AIzaSyA-jQCTyzQRnx2ymEnZI_yqa60gLyfB14k")
</pre>
</br>
3. install
<pre>
<code>
flutter pub get
</code>
</pre>
 or just CMD+s at VSCode
</br>
</br>

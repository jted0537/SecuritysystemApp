import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:security_system/main.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/src/models/chckpoint.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:security_system/src/screens/patrollingGuard/in_duty_route.dart';

//컬럼안에 높이 100주거나 앱바 사용
//그 바로 아래에는 Align Widget
// (Align -> Row (logo, loginGuard.name)
//그 아래는 이제
//local_authentication_view에서 지문사진을 박스안에 넣어놨는데 그거보고 비슷하게
//제생각에는 컨테이너 100정도 주는게 좋아보이네요
//Column내부에 컨테이너랑 맵

int lastHour;
int lastMinute;

class ViewMap extends StatefulWidget {
  @override
  _ViewMapState createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  // location
  StreamSubscription _locationSubscription;
  Location _locationTracker;
  LocationData _curLocation;
  GoogleMapController _controller;
  // markers & circles
  Marker _marker;
  //Circle _circle; // circle for cur position
  Set<Circle> _checkpointCircles = Set<Circle>();
  // status
  bool isLoading = false;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  // ids
  int _circleIdCounter = 1;

  // initializer
  @override
  void initState() {
    super.initState();
    _locationTracker = new Location();
    _initializeCurLocation();
  }

  void _initializeCurLocation() async {
    setState(() {
      isLoading = true;
    });
    _initialize();
    _curLocation = await _locationTracker.getLocation();
    if (_curLocation == null) {
      return;
    }

    setState(() {
      isLoading = false;
    });

    print("Initial CurrentLocation: $_curLocation");
  }

  Future<void> _initialize() async {
    _serviceEnabled = await _locationTracker.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationTracker.requestService();
      if (!_serviceEnabled) {
        debugPrint("Service Not Enabled");
        return;
      }
    }

    _permissionGranted = await _locationTracker.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationTracker.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        debugPrint("Permission Denied");
        return;
      }
    }
  }

  void _getCurrentLocation() async {
    try {
      Uint8List imageData = await _getMarker();
      var location = await _locationTracker.getLocation();

      _updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller
              .animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
            target: LatLng(newLocalData.latitude, newLocalData.longitude),
          )));
          _updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  Future<Uint8List> _getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("images/curlocation.png");
    return byteData.buffer.asUint8List();
  }

  void _updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      // marker size는 항상 고정 -> 줌 정도 이용해서 UI 맞추기
      _marker = Marker(
          markerId: MarkerId("guard"),
          position: latlng,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.9),
          icon: BitmapDescriptor.fromBytes(imageData));

      _checkpointCircles.add(Circle(
          circleId: CircleId("cur"),
          //radius: newLocalData.accuracy,
          radius: 40,
          zIndex: 1,
          strokeWidth: 0,
          center: latlng,
          fillColor: Colors.red.withAlpha(80)));
    });
  }

  void _updateCheckMarker(double lat, double lng, double radius) {
    LatLng latlng = LatLng(lat, lng);
    final String pointId = 'checkpoint_id_$_circleIdCounter';
    _circleIdCounter++;

    print('Checkpoint: Latitude: $lat, Longitude: $lng, Radius: $radius');

    this.setState(() {
      _checkpointCircles.add(Circle(
          circleId: CircleId(pointId),
          radius: radius,
          zIndex: 1,
          strokeWidth: 0,
          center: latlng,
          fillColor: Colors.red.withAlpha(80)));
    });
  }

  void _showChecklist() {
    // TODO: checklist 보여주기
    List<CheckPoint> curCheckpoints =
        loginRouteViewModel.loginRoute.checkpoints;
    //List<CheckPoint> curCheckpoints = [new CheckPoint(sequenceNum: 1, latitude: 37.5763, longitude: 126.9779, radius: 30.0, frequency: 4), new CheckPoint(sequenceNum: 1, latitude: 37.5664, longitude: 126.9794, radius: 30.0, frequency: 4)];
    for (var i = 0; i < curCheckpoints.length; i++) {
      _updateCheckMarker(curCheckpoints[i].latitude,
          curCheckpoints[i].longitude, curCheckpoints[i].radius);
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? AlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(rokkhiColor)),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Please wait",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    )),
                Text('Get Your Current Location...'),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: Column(children: [
                      Container(
                        height: 40.0,
                        child: topRightDismissButton(context),
                      ),
                      Container(
                        height: 50.0,
                        child: viewMapLogo(loginGuardViewModel.guardName,
                            loginGuardViewModel.type),
                      ),
                      // last checkpoint widget
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 15.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                color: Colors.grey[400],
                              )),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('images/grey_marker.png',
                                    height: 30.0, width: 30.0),
                                SizedBox(height: 10.0),
                                Text('Last Checkpoint',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 17.0,
                                      fontWeight: defaultFontWeight,
                                    )),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '${loginRouteViewModel.routeTitle}, at ${lastHour>12 ? lastHour-12 : lastHour}:$lastMinute ${lastHour>12 ? 'pm' : 'am'}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: titleFontWeight,
                                    fontSize: 21.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Google Map Container
                      Container(
                        height: 600.0,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(_curLocation.latitude,
                                  _curLocation.longitude),
                              tilt: 0,
                              zoom: 16.0),
                          markers: Set.of((_marker != null) ? [_marker] : []),
                          circles: _checkpointCircles,
                          // myLocationEnabled: true,
                          //myLocationButtonEnabled: true,
                          zoomControlsEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            _controller = controller;
                            _getCurrentLocation();
                            _showChecklist();
                          },
                          onCameraMove: (CameraPosition camPos) async {
                            await _controller.animateCamera(
                                CameraUpdate.newCameraPosition(camPos));
                            //print('ha');
                          },
                        ),
                      ),
                    ]))));
  }
}

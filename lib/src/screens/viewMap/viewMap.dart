import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:security_system/main.dart';
import 'package:security_system/src/models/chckpoint.dart';

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

  // 나중에 수정
  // static final CameraPosition initialLocation = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

   // initializer
  @override
  void initState() {
    super.initState();
    _locationTracker = new Location();
    _initializeCurLocation();
  }
  
  Future<void> initialize() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
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

      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 15.00 // user custom 되도록 설정
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
    ByteData byteData = await DefaultAssetBundle.of(context).load("images/curlocation.png");
    return byteData.buffer.asUint8List();
  }

  void _updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      _marker = Marker(
          markerId: MarkerId("guard"),
          position: latlng,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.3),
          icon: BitmapDescriptor.fromBytes(imageData));
      // _circle = Circle(
      //     circleId: CircleId("cur"),
      //     radius: newLocalData.accuracy,
      //     zIndex: 1,
      //     strokeColor: Colors.blue,
      //     center: latlng,
      //     fillColor: Colors.blue.withAlpha(60));
    });
  }

  void _updateCheckMarker(double lat, double lng, double radius) {
    LatLng latlng = LatLng(lat, lng);
    final String pointId = 'checkpoint_id_$_circleIdCounter';
    _circleIdCounter++;

    print('Checkpoint: Latitude: $lat, Longitude: $lng, Radius: $radius');

    this.setState(() {
       _checkpointCircles.add(Circle(
          circleId: CircleId("cur"),
          radius: radius,
          zIndex: 1,
          strokeColor: Colors.red,
          center: latlng,
          fillColor: Colors.red.withAlpha(60)
          )
        );
    });
  }

  void _showChecklist() {
  //  TODO: checklist 보여주기
  //  List<CheckPoint> curCheckpoints = loginRouteViewModel.loginRoute.checkpoints;
  List<CheckPoint> curCheckpoints = [new CheckPoint(sequenceNum: 1, latitude: 37.5663, longitude: 126.9779, radius: 40.0, frequency: 4), new CheckPoint(sequenceNum: 1, latitude: 37.5664, longitude: 126.9794, radius: 40.0, frequency: 4)];
   for(var i=0; i<curCheckpoints.length; i++){
     _updateCheckMarker(curCheckpoints[i].latitude, curCheckpoints[i].longitude, curCheckpoints[i].radius);
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
    return Scaffold(
      body: (_initialLocation!=null) ?GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: LatLng(_initialLocation.latitude, _initialLocation.longitude)),
        markers: Set.of((_marker != null) ? [_marker] : []),
        circles: _checkpointCircles,
        // circles: Set.of((_circle != null) ? [_circle] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          _getCurrentLocation();
          _showChecklist();
        },
        // onCameraMove: (CameraPosition camPos) {
        //   _controller.animateCamera(CameraUpdate.newCameraPosition(camPos));
        // },
      ),
    );
  }
}
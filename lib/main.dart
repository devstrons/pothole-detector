import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Control and access the map with [mapController].
  late GoogleMapController mapController;

  /// Set of [Marker] which is shown on map.
  final Set<Marker> _markers = {};

  /// Object which stores the image to make into a [Marker].
  late BitmapDescriptor mapMarker;

  Location location = Location();
  late LocationData _currentPosition;
  LatLng _initialcameraposition = LatLng(0.5937, 0.9629);

  @override
  void initState() {
    super.initState();
    setCustomMarker();
  }

  /// Convert the [AssetImage] to [BitmapDescriptor]
  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'image/marker.png',
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      /// Add the first [Marker] to the set.
      _markers.add(Marker(
        markerId: const MarkerId("Pot hole here"),
        icon: mapMarker,
        position: _center,
      ));
    });
    mapController = controller;

    LatLng current_pos;
    location.onLocationChanged.listen((l) {
      current_pos = LatLng(l.latitude!, l.longitude!);
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }

  /// The location of delhi
  final LatLng _center = const LatLng(
    28.65,
    77.23,
  );

  /// Puts a marker at the current map location
  ///
  /// Warning: Not on the physical current location
  void add_marker() async {
    LatLng _marker_pos = await mapController
        .getLatLng(ScreenCoordinate(
          x: 500,
          y: 1000,
        ))
        .then((value) => value);
    _markers.add(Marker(
      markerId: MarkerId("${_markers.length}"),
      icon: mapMarker,
      position: _marker_pos,
    ));
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    /// Check if location is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    /// Check if location permission is given
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    /// Get current position on map
    _currentPosition = await location.getLocation();
    _initialcameraposition =
        LatLng(_currentPosition.latitude!, _currentPosition.longitude!);

    /// Update [_currentPosition] when changed
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition =
            LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pothole'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              buildingsEnabled: true,
              markers: _markers,
            ),
            Positioned(
              bottom: 50,
              right: 10,
              child: FloatingActionButton(
                onPressed: add_marker,
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

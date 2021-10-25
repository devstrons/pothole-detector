import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pothole_dectector/drawer.dart';
import 'package:pothole_dectector/googlemap.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pothole'),
          backgroundColor: Colors.deepPurple,
        ),
        body: googlemap(),
        drawer: MyDrawer(),
      ),
    );
  }
}

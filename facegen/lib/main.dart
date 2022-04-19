import 'package:camera/camera.dart';
import 'package:facegen/page/result.dart';
import 'package:flutter/material.dart';
import 'package:facegen/page/lobby.dart';
import 'package:facegen/page/dropdown.dart';
import 'package:facegen/page/canvas.dart';
import 'dart:math';

List<CameraDescription> cameras = [];
Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: Canvas()
    );
  }
}

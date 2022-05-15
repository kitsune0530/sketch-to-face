// ignore_for_file: avoid_print

import 'dart:developer' as dev;


import 'package:camera/camera.dart';
import 'package:facegen/shared_prefs_helper.dart';
import 'package:facegen/sizing.dart';
import 'package:facegen/web/main_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:flutter/foundation.dart' show kIsWeb;


List<CameraDescription> cameras = [];
List<String> genderList = ['Male', 'Female'];
List<String> skinList = [
  'Light',
  'Fair',
  'Medium',
  'Brown/Red',
  'DarkBrown',
  'Black',
];
List<String> shapeList = [
  'Square/Triangle',
  'Rectangle/Oblong',
  'Round',
  'Oval/Heart',
  'Diamond/Inverted Triangle'
];
List<String> eyesList = [
  'Monolid',
  'Almond',
  'Round',
  'Down-turned',
  'Up-turned',
  'Hooded'
];
List<String> noseList = ['Small', 'Large', 'Wide', 'Narrow'];
List<String> mouthList = [
  'Small',
  'Wide/Full',
  'Thin',
  'Heart Shape',
  'Heavy Upper',
  'Heavy Lower'
];
List<String> earsList = [
  'Hidden',
  'Wide/Full',
  'Narrow',
  'Pointed',
  'Square',
  'Round'
];
List<String> hairList = [
  'None',
  'Straight-short',
  'Straight-long',
  'Wave-short',
  'Wave-long',
  'Curl-short',
  'Curl-long',
  'Coiled-short',
  'Coiled-long',
];
List<String> eyebrowsList = [
  'None',
  'Straight',
  'Flat',
  'Rounded',
  'Arched',
  'S-shape'
];
List<String> beardList = [
  'None',
  'Mustache short',
  'Beard short',
  'Beard Long'
];

List<String> desType = [
  "Gender",
  "Skin Color",
  "Face Shape",
  "Eyes",
  "Nose",
  "Mouth",
  "Ears",
  "Hair",
  "Eyebrows",
  "Beard"
];

ContextSize size = new ContextSize();
Future<void> main() async {

  SharedPrefsHelper.resetValues();

  print(">>Starting");
  // try {
  //   print(">>Start Camera");
  //   // WidgetsFlutterBinding.ensureInitialized();
  //   cameras = await availableCameras();
  //   print(">>Enable Camera Complete");
  // } on CameraException catch (e) {
  //   print(">>Error Camera");
  //   print('Error in fetching the cameras: $e');
  // }

  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    dev.log("Website");

    runApp(WebApp());
  } else {
    dev.log("Mobile App");
    runApp(MobileApp());
  }
}

class WebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);


    // return MaterialApp(
    //     title: 'Flutter Demo',
    //     theme: ThemeData.light(),
    //     home:  MainMenu()
    // );
    return MaterialApp(
        title: 'Sketch-to-Face',
        theme: ThemeData.light(),
        home:  MainWebsite()
    );
  }
}


class MobileApp extends StatelessWidget {
  const MobileApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
        title: 'Sketch-to-Face',
        theme: ThemeData.light(),
        home:  MainWebsite()
    );
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData.light(),
    //   home:  MainMenu()
    // );
  }
}


String PrintDes(String headch, String data) {
  String text = "";
  if (data != null) {
    text = data + " " + headch + "\n";
  }
  return text;
}

Container buildBorderContainer(Widget widget, double pad) {
  return Container(
    padding: EdgeInsets.all(size.getPad()),
    decoration: BoxDecoration(border: Border.all(width: 1)),
    child: Column(
      children: [widget],
    ),
  );
}

// // ignore_for_file: deprecated_member_use, prefer_const_constructors
// import 'package:external_app_launcher/external_app_launcher.dart';
// import 'package:facegen/page/canvas.dart';
// import 'package:facegen/page/view_gallery.dart';
// import 'package:facegen/shared_prefs_helper.dart';
// import 'package:facegen/sizing.dart';
// import 'package:flutter/material.dart';
// import 'package:facegen/helper/sizehelper.dart';
// import 'package:flutter/services.dart';
// // import 'package:intent/intent.dart';
//
// import 'dart:developer' as dev;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../main.dart';
//
// class MainMenu extends StatelessWidget {
//   MainMenu(){
//     SharedPrefsHelper.resetValues();
//   }
//   // ContextSize size = new ContextSize();
//
//   @override
//   Widget build(BuildContext context) {
//     double w = displayWidth(context);
//     double h = displayHeight(context);
//     MediaQuery.of(context).padding.top - kToolbarHeight;
//
//     double pad = w * 0.01;
//     double halfWidth = w * 0.5 - pad;
//     double width = w - pad;
//     double height = h - pad;
//     size.setTitleFont(w * 0.1);
//
//     size.setTextFont(w * 0.05);
//
//
//
//     size.setPad(pad);
//     size.setHalfWidth(halfWidth - pad * 10);
//     size.setWidth(width - pad);
//     size.setHeight(height - pad * 10);
//     size.setW(w);
//     size.setH(h);
//
//     return Scaffold(
//         backgroundColor: Colors.white24,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             // crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
//                   child: Container(
//                     child: Text('Face Generator',
//                         style: TextStyle(fontSize: w * 0.1, color: Colors.white, fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//               ),
//               Container(
//                 child: Column(
//                   children: [
//                     buildCanvasButton(w, context),
//                     buildImageViewerButton(w, context),
//                     buildButton()
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ));
//   }
//
//
//   Padding buildButton() {
//     return Padding(
//       padding: EdgeInsets.all(size.getPad()),
//       child: SizedBox(
//         height: size.getWidth()* 0.1,
//         width: size.getWidth()*0.7, // match_parent
//         child: RaisedButton(
//             textColor: Colors.black,
//             color: Colors.grey,
//             child: Text("Exit", style: TextStyle(fontSize: size.getTextFont())),
//             onPressed: () {
//               SystemNavigator.pop();
//             },
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0))),
//       ),
//     );
//   }
//
//
//
//   Padding buildImageViewerButton(double w, BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(size.getPad()),
//       child: SizedBox(
//         height: size.getWidth()*0.1,
//         width: size.getWidth()*0.7, // match_parent
//         child: RaisedButton(
//             textColor: Colors.black,
//             color: Colors.grey,
//             child:
//                 Text("View Saved Images", style: TextStyle(fontSize: size.getTextFont())),
//             onPressed: () async {
//               dev.log("Open Gallery");
//
//               // Navigator.push(
//               // context,
//               // MaterialPageRoute(builder: (context) => OpenGallery()),
//               // );
//
//               bool isInst = false;
//               dev.log(isInst.toString());
//               isInst = await LaunchApp.isAppInstalled(androidPackageName: "com.google.android.gallery3d",);
//               dev.log(isInst.toString());
//               isInst = await LaunchApp.isAppInstalled(androidPackageName: "com.google.android.apps.photos",);
//               dev.log(isInst.toString());
//               await LaunchApp.openApp(
//                   androidPackageName: "com.google.android.apps.photos",
//                   openStore: true,
//               );
//
//
//
//
//             },
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0))),
//       ),
//     );
//   }
//
//   Padding buildCanvasButton(double w, BuildContext context) {
//     return Padding(
//       padding:  EdgeInsets.all(size.getPad()),
//       child: SizedBox(
//         height: size.getWidth() * 0.1,
//         width: size.getWidth() * 0.7, // match_parent
//         child: RaisedButton(
//             textColor: Colors.black,
//             color: Colors.grey,
//             child: Text(
//               "Create Face",
//               style: TextStyle(fontSize:size.getTextFont()),
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => Canvas(image: null,)),
//               );
//             },
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0))),
//       ),
//     );
//   }
// }

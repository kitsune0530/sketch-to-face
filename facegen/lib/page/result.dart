// import 'dart:convert';
// // import 'dart:html';
// import 'dart:typed_data';
// import 'dart:ui';
//
// import 'dart:developer' as dev;
//
// import 'package:facegen/page/canvas.dart';
// import 'package:facegen/shared_prefs_helper.dart';
// import 'package:facegen/sizing.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:facegen/helper/sizehelper.dart';
// import 'package:flutter/rendering.dart';
// import 'package:facegen/helper/customdialog.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'package:async/async.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// import 'package:http_parser/http_parser.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;
// // import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'package:gallery_saver/gallery_saver.dart';
// import '../main.dart';
//
// class Generated extends StatefulWidget {
//   File? image;
//   Generated({Key? key, this.image}) : super(key: key);
//
//   @override
//   _GeneratedState createState() => _GeneratedState(image!);
// }
//
// class _GeneratedState extends State<Generated> {
//   File? genFile;
//   String stringByte = "";
//   Image? img1;
//   Image? img2;
//   Image? img3;
//   List<Image>? generatedImage = List<Image>.empty(growable: true);
//
//   int selectedIntex = 0;
//
//   String? gender,
//       _choosenSkin,
//       _choosenShape,
//       _choosenEyes,
//       _choosenNose,
//       _choosenMouth,
//       _choosenEars,
//       _choosenHair,
//       _choosenEyebrows,
//       _choosenBeard;
//   File? input;
//   String? _saveProgress = "";
//   Uint8List temp = new Uint8List(1);
//   List<Uint8List>?  generatedByte;
//
//   Future<List<int>>? descriptionList;
//
//   _GeneratedState(File image) {
//     generatedByte = List<Uint8List>.filled(3, temp, growable: true);
//     this.input = image;
//     setChosen();
//     descriptionList = getDescriptionList();
//     generatedImage?.add(Image.file(input!));
//     generatedImage?.add(Image.file(input!));
//     generatedImage?.add(Image.file(input!));
//     String? ImgLength = generatedImage?.length.toString();
//     dev.log("[DEBUG] [Constructor] >>> GenerateImage Length : " + ImgLength!);
//   }
//
//   Future<List<int>> getDescriptionList() async {
//     List<List<String>> sumsDes = [
//       genderList,
//       skinList,
//       shapeList,
//       eyesList,
//       noseList,
//       mouthList,
//       earsList,
//       hairList,
//       eyebrowsList,
//       beardList
//     ];
//     int sumsLength = sumsDes.length;
//     // dev.log("sumsLength  = " + sumsLength.toString());
//     dev.log(" >>> Start Loop");
//     int i = 0;
//     List<int> tempList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
//     for (i; i < sumsLength; i = i + 1) {
//       String temp = await SharedPrefsHelper.getValue(desType[i]);
//       int idx = sumsDes[i].indexWhere((element) => element == temp);
//       tempList[i] = idx;
//     }
//     dev.log(" >>> End Loop ${i.toString()}");
//     dev.log("Index " " : " + descriptionList.toString());
//
//     dev.log(" >>> Start Uploading");
//     try {
//       for (i = 0; i < 3; i++) {
//         var request = http.MultipartRequest(
//           'POST',
//           // Uri.parse("http://192.168.245.3:8086/generate"),
//           // Uri.parse("http://52.148.83.67/generate"),
//           Uri.parse("http://10.160.131.121:8086/generate"),
//         );
//         Map<String, String> headers = {"Content-type": "multipart/form-data"};
//         int length = 10;
//
//         for (var j = 0; j < length; j++) {
//           request.fields[desType[j]] = tempList[j].toString();
//
//           // dev.log(request.fields[desType[i]]!);
//         }
//         request.files.add(
//           http.MultipartFile(
//             'image',
//             input!.readAsBytes().asStream(),
//             input!.lengthSync(),
//             filename: "filename",
//             contentType: MediaType('image', 'png'),
//           ),
//         );
//
//         // dev.log(request.files.toString());
//         dev.log(request.fields.toString());
//
//         dev.log("[DEBUG] >>> Upload Round: " + i.toString());
//         request.fields['randomIdx'] = i.toString();
//         request.headers.addAll(headers);
//
//         dev.log("[DEBUG] >>> Request Data: " + request.toString());
//         var response = await request.send();
//         dev.log("[DEBUG] >>> Response Code: " + response.statusCode.toString());
//         var resBytes = await response.stream.toBytes();
//
//         dev.log("[DEBUG] >>> Response: Get Stream.");
//
//         generatedByte![i] = resBytes.buffer.asUint8List();
//         dev.log("[DEBUG] >>> Convery Stream to Uint8List");
//         generatedImage![i] = Image.memory(resBytes.buffer.asUint8List());
//         // generatedImage?.add(Image.memory(resBytes.buffer.asUint8List())) ;
//         dev.log("[DEBUG] >>> Save Image into List.");
//         setState(() {});
//         await Future.delayed(Duration(seconds: 1));
//       }
//
//     } catch (e) {
//       dev.log(" >>> Exception Uploading");
//       dev.log(e.toString());
//     }
//
//     return tempList;
//   }
//
//   void setChosen() async {
//     SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//
//     setState(() {
//       gender = sharedPrefs.getString(desType[0]);
//       _choosenSkin = sharedPrefs.getString("Skin Color");
//       _choosenShape = sharedPrefs.getString("Face Shape");
//       _choosenEyes = sharedPrefs.getString("Eyes");
//       _choosenNose = sharedPrefs.getString("Nose");
//       _choosenMouth = sharedPrefs.getString("Mouth");
//       _choosenEars = sharedPrefs.getString("Ears");
//       _choosenHair = sharedPrefs.getString("Hair");
//       _choosenEyebrows = sharedPrefs.getString("Eyebrows");
//       _choosenBeard = sharedPrefs.getString("Beard");
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   // ContextSize size = new ContextSize();
//
//   @override
//   Widget build(BuildContext context) {
//     double w = displayWidth(context);
//     double h = displayWidth(context);
//     MediaQuery.of(context).padding.top - kToolbarHeight;
//
//     // double pad = w * 0.01;
//     // double halfWidth = w * 0.5 - pad;
//     // double width = w - pad;
//     // double height = h - pad;
//     // size.setTitleFont(w * 0.1);
//     //
//     // size.setTextFont(w * 0.05);
//     //
//     //
//     //
//     // size.setPad(pad);
//     // size.setHalfWidth(halfWidth - pad * 10);
//     // size.setWidth(width - pad);
//     // size.setHeight(height - pad * 10);
//     // size.setW(w);
//     // size.setH(h);
//     // dev.log(descriptionList);
//
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(size.getPad()),
//         child: SafeArea(
//           child: Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 // buildFutureDropdown(w,h),
//                 buildCanvas(w, h),
//                 Container(
//                   child: Padding(
//                     padding: EdgeInsets.all(size.getPad() * 5),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         buildSelectImageBtn(0),
//                         buildSelectImageBtn(1),
//                         buildSelectImageBtn(2),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // buildDescription(w, h, context),
//                 buildButtons(w, context)
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   RaisedButton buildSelectImageBtn(int idx) {
//     String strIdx = (idx+1).toString();
//     return RaisedButton(
//       textColor: Colors.black,
//       color: Colors.grey,
//       child: Text(strIdx, style: TextStyle(fontSize: size.getTextFont())),
//       onPressed: () {
//         selectedIntex = idx;
//         setState(() {});
//       },
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//     );
//   }
//
//   Future<String> uint8ToFile(Uint8List imageInUnit8List, String number) async {
//     final tempDir = await getTemporaryDirectory();
//     File file = await File('${tempDir.path}/generated${number}.png').create();
//     print('${tempDir.path}/generated${number}.png');
//     file.writeAsBytesSync(imageInUnit8List);
//     dev.log("Image Path : " + '${tempDir.path}/generated${number}.png');
//     return ('${tempDir.path}/generated${number}.png');
//   }
//
//   FutureBuilder<List<int>> buildFutureDropdown(double h, double w) {
//     dev.log("Build Canvas ");
//     return FutureBuilder<List<int>>(
//       future: getDescriptionList(),
//       builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
//         print("[Debug] >>> Starting");
//         if (snapshot.hasData) {
//           print("[Debug] >>> " + snapshot.data.toString());
//           // this.descriptionList = snapshot.data;
//           // doUpload();
//         } else {
//           print("[Debug] >>> ERROR Retrieving");
//         }
//
//         print("[Debug] >>> Description List = " + descriptionList.toString());
//         // return snapshot.hasData
//         //     ? buildCanvas(w,h)
//         //     : Container(
//         //   child: Text("Test"),
//         // );
//
//         return buildCanvas(w, h);
//       },
//     );
//   }
//
//   Column buildCanvas(double w, double h) {
//     return Column(
//       children: [
//         Text("Generated Face", style: TextStyle(fontSize: size.getTitleFont())),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//                 child: generatedImage![selectedIntex] != null
//                     ? Container(
//                         width: w * 0.95,
//                         height: h * 0.95,
//                         decoration: BoxDecoration(
//                             image: DecorationImage(
//                               fit: BoxFit.contain,
//                               image: generatedImage![selectedIntex].image,
//                             ),
//                             border: Border.all(width: 1)),
//                       )
//                     : Container(
//                         decoration: BoxDecoration(border: Border.all(width: 1)),
//                         width: w * 0.95,
//                         height: h * 0.95,
//                         //child:  _show(picture, context),
//                       )),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Padding buildDescription(double w, double h, BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(h * 0.04, h * 0.02, h * 0.04, h * 0.02),
//       child: Column(
//         children: [
//           Text("Descriptions", style: TextStyle(fontSize: 20)),
//           Container(
//             width: w * 0.95,
//             height: h * 0.5,
//             child: Padding(
//                 padding: EdgeInsets.all(size.getPad()),
//                 child: Scrollbar(
//                   child: SingleChildScrollView(
//                     child: Text(
//                       "${gender}\n"
//                       "${PrintDes("skin, ", _choosenSkin!)}"
//                       "${PrintDes("shape, ", _choosenShape!)}"
//                       "${PrintDes("eyes, ", _choosenEyes!)}"
//                       "${PrintDes("nose, ", _choosenNose!)}"
//                       "${PrintDes("mouth, ", _choosenMouth!)}"
//                       "${PrintDes("ears, ", _choosenEars!)}"
//                       "${PrintDes("hair, ", _choosenHair!)}"
//                       "${PrintDes("eyebrows, ", _choosenEyebrows!)}"
//                       "${PrintDes("beard", _choosenBeard!)}",
//                       style: TextStyle(fontSize: size.getTextFont()),
//                     ),
//                   ),
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Expanded buildButtons(double w, BuildContext context) {
//     return Expanded(
//       child: Column(
//         children: [
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             SizedBox(
//               height: size.getWidth() * 0.1,
//               width: size.getWidth() * 0.7, // match_parent
//               child: RaisedButton(
//                   textColor: Colors.black,
//                   color: Colors.blue,
//                   child: Text("Edit Sketch / Description",
//                       style: TextStyle(fontSize: size.getTextFont())),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0))),
//             )
//           ]),
//           Padding(
//             padding: EdgeInsets.all(size.getPad() * 2),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.save_alt_outlined),
//                   iconSize: size.getTextFont(),
//                   splashColor: Colors.black,
//                   onPressed: () async {
//                     // android.permission.WRITE_EXTERNAL_STORAGE;
//                     dev.log("Saving In Progress");
//
//                     await uint8ToFile(generatedByte![selectedIntex], "1").then((value) {
//                       print(this.genFile.toString());
//                       // this.genFile = File.fromRawPath(generatedByte);
//
//                       this.genFile = File(value);
//                       print(this.genFile.toString());
//                     });
//
//                     if (genFile == null) {
//                       dev.log("No File To Save!");
//                       return null;
//                     } else {
//                       dev.log("Saving In Progress");
//                       final Directory extDir =
//                           await getApplicationDocumentsDirectory();
//                       String dirPath = extDir.path;
//
//                       DateTime now = DateTime.now();
//                       DateTime date = DateTime(now.year, now.month, now.day,
//                           now.hour, now.minute, now.second);
//                       final String fileName =
//                           basename("save${date.toString()}.png");
//                       final File localImage =
//                           await genFile!.copy('$dirPath/$fileName')!;
//
//                       if (genFile != null && genFile!.path != null) {
//                         setState(() {
//                           // _saveProgress = 'saving in progress...';
//                         });
//
//                         GallerySaver.saveImage(genFile!.path);
//                         setState(() {
//                           // _saveProgress = 'Save Complelted...';
//                         });
//                         // dev.log(_saveProgress);
//
//                         dev.log("Save Successfully");
//                         // return AlertDialog(
//                         //   title: Text("Image Saved",style: TextStyle(fontSize: size.getTextFont()),),
//                         // );
//                         showSaved(context);
//                       }
//                     }
//                   },
//                 ),
//                 IconButton(
//                     iconSize: size.getTextFont(),
//                     onPressed: () => showDialog(
//                           barrierColor: Colors.black26,
//                           context: context,
//                           builder: (context) {
//                             // return Container(
//                             //   child: AlertDialog(
//                             //     title: Text("Image Saved." ,textAlign: TextAlign.center,style: TextStyle(fontSize: size.getTextFont()),),
//                             //   ),
//                             // );
//                             return CustomAlertDialog(
//                               title: "Warning!",
//                               description:
//                                   "The created image will disappear\n" +
//                                       "Want to return to the main page?",
//                             );
//                           },
//                         ),
//                     icon: const Icon(
//                       Icons.home_sharp,
//                     ))
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget okButton = TextButton(
//     child: const Text("OK"),
//     onPressed: () {},
//   );
//
//   showSaved(BuildContext context) {
//     String currImg = (selectedIntex+1).toString();
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             "Image "+currImg+" Saved",
//             style: TextStyle(fontSize: size.getTextFont()),
//           ),
//           actions: [ ],
//         );
//       },
//     );
//   }
//
// }

// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:developer' as dev;
// import 'package:facegen/helper/customdialog.dart';
// import 'package:http/http.dart' as http;
//
// import 'package:image_downloader_web/image_downloader_web.dart';
// import 'package:facegen/helper/sizehelper.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'package:facegen/shared_prefs_helper.dart';
// import 'package:flutter/rendering.dart';
//
// import 'package:http_parser/http_parser.dart';
//
// import '../main.dart';
// import '../shared_prefs_helper.dart';
//
// class WebSummary extends StatefulWidget {
//   Image? image;
//   Uint8List? imageUint8;
//   WebSummary({Key? key, this.image, this.imageUint8}) : super(key: key);
//
//   WebSummary.setImage({
//     Key? key,
//     this.image,
//   }) : super(key: key);
//
//   @override
//   _WebSummaryState createState() => _WebSummaryState(image!, imageUint8!);
// }
//
// class _WebSummaryState extends State<WebSummary> {
//   /*
//   *
//   *
//   *
//   *     Summary
//   *
//   *
//   *
//    */
//
//   final WebImageDownloader _webImageDownloader = WebImageDownloader();
//   File? genFile;
//   String stringByte = "";
//   Image? img1;
//   Image? img2;
//   Image? img3;
//   List<Image>? generatedImage = List<Image>.empty(growable: true);
//
//   int selectedIntex = 0;
//
//   String gender='',
//       _choosenSkin='',
//       _choosenShape='',
//       _choosenEyes='',
//       _choosenNose='',
//       _choosenMouth='',
//       _choosenEars='',
//       _choosenHair='',
//       _choosenEyebrows='',
//       _choosenBeard='';
//   // File? input;
//   Image? input;
//   String? _saveProgress = "";
//   Uint8List temp = new Uint8List(1);
//   List<Uint8List>?  generatedByte;
//   final ScrollController controllerOne = ScrollController();
//   final ScrollController controllerTwo = ScrollController();
//   Uint8List? uint8ListImage;
//
//   Future<List<int>>? descriptionList;
//
//   _WebSummaryState(Image image, Uint8List uint8list) {
//     generatedByte = List<Uint8List>.filled(3, temp, growable: true);
//     uint8ListImage = uint8list;
//     this.input = image;
//     setChosen();
//     descriptionList = getDescriptionList();
//     generatedImage?.add(input!);
//     generatedImage?.add(input!);
//     generatedImage?.add(input!);
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
//
//         dev.log("[DEBUG] >>> Upload Round: " + i.toString());
//
//         var request = http.MultipartRequest(
//           'POST',
//           // Uri.parse("http://192.168.245.3:8086/generate"),
//           // Uri.parse("http://52.148.83.67/generate"),
//           Uri.parse("http://10.160.131.121:8086/generate"),
//         );
//         Map<String, String> headers = {"Content-type": "multipart/form-data"};
//         int length = 10;
//
//         dev.log("[DEBUG] >>> Set Request Uri");
//
//         for (var j = 0; j < length; j++) {
//           request.fields[desType[j]] = tempList[j].toString();
//         }
//
//         dev.log("[DEBUG] >>> Set Field Uri ");
//
//         Future<Uint8List> futureUint8(Uint8List uint8) async {
//           return uint8;
//         }
//
//         Stream<Uint8List> stream = Stream<Uint8List>.fromFuture(futureUint8(uint8ListImage!));
//
//         request.files.add(
//           http.MultipartFile(
//             'image',
//             stream,
//             uint8ListImage!.lengthInBytes,
//             filename: "filename",
//             contentType: MediaType('image', 'png'),
//           ),
//         );
//
//         dev.log("[DEBUG] >>> Set File :" + request.files.toString());
//
//         dev.log("[DEBUG] >>> Set Request File :" + request.files.toString());
//
//         // dev.log(request.files.toString());
//         dev.log(request.fields.toString());
//
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
//   void setChosen() async {
//     SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//
//     setState(() {
//       gender = sharedPrefs.getString(desType[0])!;
//       _choosenSkin = sharedPrefs.getString("Skin Color")!;
//       _choosenShape = sharedPrefs.getString("Face Shape")!;
//       _choosenEyes = sharedPrefs.getString("Eyes")!;
//       _choosenNose = sharedPrefs.getString("Nose")!;
//       _choosenMouth = sharedPrefs.getString("Mouth")!;
//       _choosenEars = sharedPrefs.getString("Ears")!;
//       _choosenHair = sharedPrefs.getString("Hair")!;
//       _choosenEyebrows = sharedPrefs.getString("Eyebrows")!;
//       _choosenBeard = sharedPrefs.getString("Beard")!;
//     });
//   }
//
//   /*
//   *
//   *
//   *
//   *     Build
//   *
//   *
//   *
//    */
//
//   double canvasSize = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     double w = displayWidth(context);
//     double h = displayHeight(context);
//     MediaQuery.of(context).padding.top - kToolbarHeight;
//     dev.log(w.toString() + " " + h.toString());
//
//     // this.titleFont = h * 0.04;
//     // this.textFont = h * 0.02;
//     //
//     // double pad = w * 0.01;
//     // double halfWidth = w * 0.5 - pad;
//     // double width = w - pad;
//     // double height = h - pad;
//     // this.pad = pad;
//     // this.halfWidth = halfWidth - pad * 10;
//     // this.width = width - pad;
//     // this.height = height - pad * 10;
//     // // this.height = height - pad * 10;
//     // this.w = w;
//     // this.h = h;
//     //
//     this.canvasSize = 128 * 4.toDouble();
//
//     return Scaffold(
//       // bottomNavigationBar: buildBottomAppBar(w, context),
//       body: Padding(
//         padding: EdgeInsets.all(size.getPad()),
//         child: Container(
//           child: Scrollbar(
//             controller: controllerOne,
//             child: ListView(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     buildBorderContainer(
//                         Container(
//                           width: size.getHalfWidth(),
//                           height: size.getHalfWidth(),
//                           child: Column(
//                             children: [
//                               buildSumCanvas(),
//                               buildSumDescription(),
//                             ],
//                           ),
//                         ),
//                         size.getPad()),
//                     buildBorderContainer(
//                         Container(
//                           width: size.getHalfWidth(),
//                           height: size.getHalfWidth(),
//                           child: Column(
//                             children: [buildResult(), buildSelectOutput(), buildButtons(context)],
//                           ),
//                         ),
//                         size.getPad())
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   /*
//   *
//   *
//   *
//   *     Widget
//   *
//   *
//   *
//    */
//
//   Padding buildSelectOutput() {
//     return Padding(
//       padding: EdgeInsets.only(top: size.getPad(), bottom: size.getPad()),
//       child: Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             buildSelectImageBtn(0),
//             buildSelectImageBtn(1),
//             buildSelectImageBtn(2),
//           ],
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
//   Column buildSumCanvas() {
//     print(" >>> Build Sum Canvas");
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       // crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(top: size.getPad(), bottom: size.getPad()),
//           child: Text("Sketch and Description",
//               style:
//                   TextStyle(fontSize: size.getTitleFont(), fontWeight: FontWeight.bold)),
//         ),
//         Container(
//           child: uint8ListImage != null
//               ? Container(
//                   width: canvasSize,
//                   height: canvasSize,
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: Image.memory(uint8ListImage!).image,
//                       ),
//                       border: Border.all(width: 1)),
//                 )
//               : Container(
//                   decoration: BoxDecoration(border: Border.all(width: 1)),
//                   width: canvasSize,
//                   height: canvasSize,
//                   //child:  _show(picture, context),
//                 ),
//         ),
//       ],
//     );
//   }
//
//   Expanded buildSumDescription() {
//     return Expanded(
//       child: Container(
//         width: this.canvasSize,
//         // height: h * 0.3,
//         child: Padding(
//             padding:
//                 EdgeInsets.all(size.getPad()),
//             child: Scrollbar(
//               controller: controllerTwo,
//               isAlwaysShown: true,
//               child: SingleChildScrollView(
//                 child: Text(
//                   "${gender}\n"
//                   "${PrintDes("skin, ", _choosenSkin)}"
//                   "${PrintDes("shape, ", _choosenShape)}"
//                   "${PrintDes("eyes, ", _choosenEyes)}"
//                   "${PrintDes("nose, ", _choosenNose)}"
//                   "${PrintDes("mouth, ", _choosenMouth)}"
//                   "${PrintDes("ears, ", _choosenEars)}"
//                   "${PrintDes("hair, ", _choosenHair)}"
//                   "${PrintDes("eyebrows, ", _choosenEyebrows)}"
//                   "${PrintDes("beard", _choosenBeard)}",
//                   style: TextStyle(fontSize: size.getTextFont()),
//                 ),
//               ),
//             )),
//       ),
//     );
//   }
//
//
//   /*
//   *
//   *
//   *
//   *     Result
//   *
//   *
//   *
//    */
//
//   void setChoosed() async {
//     SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//     setState(() {
//       gender = sharedPrefs.getString(desType[0])!;
//       _choosenSkin = sharedPrefs.getString("Skin Color")!;
//       _choosenShape = sharedPrefs.getString("Face Shape")!;
//       _choosenEyes = sharedPrefs.getString("Eyes")!;
//       _choosenNose = sharedPrefs.getString("Nose")!;
//       _choosenMouth = sharedPrefs.getString("Mouth")!;
//       _choosenEars = sharedPrefs.getString("Ears")!;
//       _choosenHair = sharedPrefs.getString("Hair")!;
//       _choosenEyebrows = sharedPrefs.getString("Eyebrows")!;
//       _choosenBeard = sharedPrefs.getString("Beard")!;
//     });
//   }
//
//   Column buildResult() {
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(top:size.getPad(), bottom: size.getPad()),
//           child: Text("Generated Face",
//               style: TextStyle(fontSize: size.getTitleFont(), fontWeight: FontWeight.bold)),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//                 child: generatedImage![selectedIntex] != null
//                     ? Container(
//                         width: this.canvasSize,
//                         height: this.canvasSize,
//                         decoration: BoxDecoration(
//                             image: DecorationImage(
//                               fit: BoxFit.contain,
//                               image: generatedImage![selectedIntex].image,
//                             ),
//                             border: Border.all(width: 1)),
//                       )
//                     : Container(
//                         decoration: BoxDecoration(border: Border.all(width: 1)),
//                         width: this.canvasSize,
//                         height: this.canvasSize,
//                       )),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Padding buildButtons(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: size.getPad(), bottom: size.getPad()),
//       child: Column(
//         children: [
//           Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//             IconButton(
//               icon: const Icon(Icons.save_alt_outlined),
//               splashColor: Colors.black,
//               onPressed: () async {
//                 await _webImageDownloader.downloadImageFromUInt8List(uInt8List: generatedByte![selectedIntex]) ;
//               },
//             ), SizedBox(
//               // width: pad*5,
//               height: size.getPad()*2,
//               child: RaisedButton(
//
//                   textColor: Colors.black,
//                   color: Colors.blue,
//                   child: Text(
//                     "Edit Sketch or Description", style: TextStyle(fontSize: size.getTextFont()),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                     Navigator.pop(context);
//                   },
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0))),
//             ),
//             IconButton(
//                 onPressed: () => showDialog(
//                   barrierColor: Colors.black26,
//                   context: context,
//                   builder: (context) {
//                     return SizedBox(
//                       width: size.getHalfWidth()/2,
//                       height: size.getHalfWidth()/2,
//                       child:
//                       CustomAlertDialog(
//                         title: "Warning!",
//                         description: "The created image will disappear\n" +
//                             "Make sure to save the image before return."
//                       ),
//                     );
//                   },
//                 ),
//                 icon: Icon(Icons.home_sharp))
//           ]),
//
//         ],
//       ),
//     );
//   }
// }

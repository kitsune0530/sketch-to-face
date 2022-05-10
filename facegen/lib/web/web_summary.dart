import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as dev;
import 'package:facegen/helper/customdialog.dart';
import 'package:http/http.dart' as http;

import 'package:facegen/helper/sizehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_draw/painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:facegen/shared_prefs_helper.dart';
import 'package:flutter/rendering.dart';

import 'package:http_parser/http_parser.dart';

import '../main.dart';
import '../shared_prefs_helper.dart';

class WebSummary extends StatefulWidget {
  Image image;
  Uint8List imageUint8;
  WebSummary({Key key, this.image, this.imageUint8}) : super(key: key);

  WebSummary.setImage({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  _WebSummaryState createState() => _WebSummaryState(image, imageUint8);
}

class _WebSummaryState extends State<WebSummary> {
  /*
  *
  *
  *
  *     Summary
  *
  *
  *
   */

  bool _finished = false;

  String gender;
  String _choosenSkin;
  String _choosenShape;
  String _choosenEyes;
  String _choosenNose;
  String _choosenMouth;
  String _choosenEars;
  String _choosenHair;
  String _choosenEyebrows;
  String _choosenBeard;
  Image image;
  Uint8List imageUint8;

  final picker = ImagePicker();

  double pad,
      halfWidth,
      width,
      height,
      w,
      h,
      titleFont,
      textFont,
      canvasSize = 0;
  double canvas = 128;

  _WebSummaryState(Image image, Uint8List imageUint8) {
    this.imageUint8 = null;
    this.imageUint8 = imageUint8;
    print(" >>> Create Summary");
    this.image = null;
    print(" >>> Set Image =  null");
    this.image = image;
    print(" >>> Set New Image");

    this.input = image;
    descriptionList = getDescriptionList();

    setChoosed();
  }

  /*
  *
  *
  *
  *     Upload
  *
  *
  *
   */

  String stringByte = "";
  Image generatedImage;

  Image input;

  Uint8List generatedByte;

  Future<List<int>> descriptionList;

  Future<List<int>> getDescriptionList() async {
    List<List<String>> sumsDes = [
      genderList,
      skinList,
      shapeList,
      eyesList,
      noseList,
      mouthList,
      earsList,
      hairList,
      eyebrowsList,
      beardList
    ];
    int sumsLength = sumsDes.length;
    // dev.log("sumsLength  = " + sumsLength.toString());
    dev.log(" >>> Start Loop");
    int i = 0;
    List<int> tempList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    for (i; i < sumsLength; i = i + 1) {
      String temp = await SharedPrefsHelper.getValue(desType[i]);
      // dev.log(temp+"[Length "+temp.length.toString()+"]");
      // dev.log("List " + i.toString() + " : " + sumsDes[i].toString());
      int idx = sumsDes[i].indexWhere((element) => element == temp);
      // descriptionList[i] = idx;
      tempList[i] = idx;
      // dev.log("Index " +
      //     i.toString() +
      //     " : " +
      //     descriptionList[i].toString() +
      //     "(${temp})");
    }
    dev.log(" >>> End Loop ${i.toString()}");
    dev.log("Index " " : " + descriptionList.toString());

    dev.log(" >>> Start Uploading");
    try {
      var request = http.MultipartRequest(
        'POST',
        // Uri.parse("http://192.168.245.3:8086/generate"),
        Uri.parse("http://10.160.131.121:8086/generate"),
      );
      Map<String, String> headers = {"Content-type": "multipart/form-data"};
      int length = 10;

      for (var i = 0; i < length; i++) {
        request.fields[desType[i]] = tempList[i].toString();

        dev.log(request.fields[desType[i]]);
      }

      Future<Uint8List> futureUint8(Uint8List uint8) async {
        return uint8;
      }

      Stream<Uint8List> stream =
          Stream<Uint8List>.fromFuture(futureUint8(imageUint8));

      request.files.add(
        http.MultipartFile(
          'image',
          stream,
          imageUint8.lengthInBytes,
          filename: "filename",
          contentType: MediaType('image', 'png'),
        ),
      );

      dev.log(request.files.toString());
      dev.log(request.fields.toString());
      request.headers.addAll(headers);

      print("[DEBUG] >>> Request Data: " + request.toString());
      var response = await request.send();
      print("[DEBUG] >>> Response Code: " + response.statusCode.toString());
      var resBytes = await response.stream.toBytes();

      generatedByte = resBytes.buffer.asUint8List();
      generatedImage = Image.memory(resBytes.buffer.asUint8List());

      setState(() {});
    } catch (e) {
      dev.log(" >>> Exception Uploading");
      dev.log(e.toString());
    }

    return tempList;
  }

  void setChosen() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    setState(() {
      gender = sharedPrefs.getString(desType[0]);
      _choosenSkin = sharedPrefs.getString("Skin Color");
      _choosenShape = sharedPrefs.getString("Face Shape");
      _choosenEyes = sharedPrefs.getString("Eyes");
      _choosenNose = sharedPrefs.getString("Nose");
      _choosenMouth = sharedPrefs.getString("Mouth");
      _choosenEars = sharedPrefs.getString("Ears");
      _choosenHair = sharedPrefs.getString("Hair");
      _choosenEyebrows = sharedPrefs.getString("Eyebrows");
      _choosenBeard = sharedPrefs.getString("Beard");
    });
  }

  /*
  *
  *
  *
  *     Build
  *
  *
  *
   */

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context);
    MediaQuery.of(context).padding.top - kToolbarHeight;
    dev.log(w.toString() + " " + h.toString());

    this.titleFont = h * 0.04;
    this.textFont = h * 0.02;

    double pad = w * 0.01;
    double halfWidth = w * 0.5 - pad;
    double width = w - pad;
    double height = h - pad;
    this.pad = pad;
    this.halfWidth = halfWidth - pad * 10;
    this.width = width - pad;
    this.height = height - pad * 10;
    // this.height = height - pad * 10;
    this.w = w;
    this.h = h;

    this.canvasSize = 128 * 4.toDouble();

    return Scaffold(
      // bottomNavigationBar: buildBottomAppBar(w, context),
      body: Padding(
        padding: EdgeInsets.all(pad),
        child: Container(
          child: Scrollbar(
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildBorderContainer(
                        Container(
                          width: this.halfWidth,
                          height: this.height,
                          child: Column(
                            children: [
                              buildSumCanvas(),
                              buildSumDescription(),
                            ],
                          ),
                        ),
                        pad),
                    buildBorderContainer(
                        Container(
                          width: this.halfWidth,
                          height: this.height,
                          child: Column(
                            children: [buildResult(), buildSelectOutput(), buildButtons(context)],
                          ),
                        ),
                        pad)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*
  *
  *
  *
  *     Widget
  *
  *
  *
   */

  Padding buildSelectOutput() {
    return Padding(
      padding: EdgeInsets.only(top: pad, bottom: pad),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              textColor: Colors.black,
              color: Colors.grey,
              child: Text(
                "1",
                style: TextStyle(fontSize: textFont)
              ),
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            RaisedButton(
              textColor: Colors.black,
              color: Colors.grey,
              child: Text(
                "2",
                  style: TextStyle(fontSize: textFont)
              ),
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            RaisedButton(
              textColor: Colors.black,
              color: Colors.grey,
              child: Text(
                "3",
                  style: TextStyle(fontSize: textFont)
              ),
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            )
          ],
        ),
      ),
    );
  }

  Column buildSumCanvas() {
    print(" >>> Build Sum Canvas");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: this.pad, bottom: this.pad),
          child: Text("Sketch and Description",
              style:
                  TextStyle(fontSize: titleFont, fontWeight: FontWeight.bold)),
        ),
        Container(
          child: this.image != null
              ? Container(
                  width: canvasSize,
                  height: canvasSize,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: this.image.image,
                      ),
                      border: Border.all(width: 1)),
                )
              : Container(
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  width: canvasSize,
                  height: canvasSize,
                  //child:  _show(picture, context),
                ),
        ),
      ],
    );
  }

  Expanded buildSumDescription() {
    return Expanded(
      child: Container(
        width: this.canvasSize,
        // height: h * 0.3,
        child: Padding(
            padding:
                EdgeInsets.fromLTRB(h * 0.01, h * 0.01, h * 0.01, h * 0.01),
            child: Scrollbar(
              isAlwaysShown: true,
              child: SingleChildScrollView(
                child: Text(
                  "${gender}\n"
                  "${PrintDes("skin, ", _choosenSkin)}"
                  "${PrintDes("shape, ", _choosenShape)}"
                  "${PrintDes("eyes, ", _choosenEyes)}"
                  "${PrintDes("nose, ", _choosenNose)}"
                  "${PrintDes("mouth, ", _choosenMouth)}"
                  "${PrintDes("ears, ", _choosenEars)}"
                  "${PrintDes("hair, ", _choosenHair)}"
                  "${PrintDes("eyebrows, ", _choosenEyebrows)}"
                  "${PrintDes("beard", _choosenBeard)}",
                  style: TextStyle(fontSize: textFont),
                ),
              ),
            )),
      ),
    );
  }

  BottomAppBar buildBottomAppBar(double w, BuildContext context) {
    return BottomAppBar(
      // color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: w * 0.2,
            child: FlatButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DropdownPage(
                  //       image: this.image,
                  //     ),
                  //   ),
                  // )
                  Navigator.pop(context);
                },
                child: const Text("back"),
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
          ),
          SizedBox(
            width: w * 0.4,
            child: FlatButton(
              onPressed: () {
                // this.image = null;

                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => null,
                  ),
                );
              },
              child: const Text("Generate"),
              color: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*
  *
  *
  *
  *     Result
  *
  *
  *
   */

  void setChoosed() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      gender = sharedPrefs.getString(desType[0]);
      _choosenSkin = sharedPrefs.getString("Skin Color");
      _choosenShape = sharedPrefs.getString("Face Shape");
      _choosenEyes = sharedPrefs.getString("Eyes");
      _choosenNose = sharedPrefs.getString("Nose");
      _choosenMouth = sharedPrefs.getString("Mouth");
      _choosenEars = sharedPrefs.getString("Ears");
      _choosenHair = sharedPrefs.getString("Hair");
      _choosenEyebrows = sharedPrefs.getString("Eyebrows");
      _choosenBeard = sharedPrefs.getString("Beard");
    });
  }

  Column buildResult() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top:pad, bottom: pad),
          child: Text("Generated Face",
              style: TextStyle(fontSize: titleFont, fontWeight: FontWeight.bold)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: generatedImage != null
                    ? Container(
                        width: this.canvasSize,
                        height: this.canvasSize,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: generatedImage.image,
                            ),
                            border: Border.all(width: 1)),
                      )
                    : Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        width: this.canvasSize,
                        height: this.canvasSize,
                      )),
          ],
        ),
      ],
    );
  }

  Column buildDescription(BuildContext context) {
    return Column(
      children: [
        Text("Descriptions", style: TextStyle(fontSize: 20)),
        Container(
          width: halfWidth,
          height: h * 0.5,
          child: Padding(
              child: Scrollbar(
            isAlwaysShown: true,
            child: SingleChildScrollView(
              child: Text(
                "${gender}\n"
                "${PrintDes("skin, ", _choosenSkin)}"
                "${PrintDes("shape, ", _choosenShape)}"
                "${PrintDes("eyes, ", _choosenEyes)}"
                "${PrintDes("nose, ", _choosenNose)}"
                "${PrintDes("mouth, ", _choosenMouth)}"
                "${PrintDes("ears, ", _choosenEars)}"
                "${PrintDes("hair, ", _choosenHair)}"
                "${PrintDes("eyebrows, ", _choosenEyebrows)}"
                "${PrintDes("beard", _choosenBeard)}",
                style: TextStyle(fontSize: h * 0.05),
              ),
            ),
          )),
        ),
      ],
    );
  }

  Padding buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: pad, bottom: pad),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
              icon: const Icon(Icons.save_alt_outlined),
              splashColor: Colors.black,
              onPressed: () async {
                


              },
            ), SizedBox(
              // width: pad*5,
              height: this.pad*2,
              child: RaisedButton(

                  textColor: Colors.black,
                  color: Colors.blue,
                  child: Text(
                    "Edit Sketch or Description", style: TextStyle(fontSize: this.textFont),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
            IconButton(
                onPressed: () => showDialog(
                  barrierColor: Colors.black26,
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      width: this.halfWidth/2,
                      height: this.halfWidth/2,
                      child: Text("a")
                      // CustomAlertDialog(
                      //   title: "Warning!",
                      //   description: "The created image will disappear\n" +
                      //       "Make sure to save the image before return."
                      // ),
                    );
                  },
                ),
                icon: Icon(Icons.home_sharp))
          ]),

        ],
      ),
    );
  }
}

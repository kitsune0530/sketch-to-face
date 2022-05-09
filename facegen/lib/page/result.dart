import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'dart:developer' as dev;

import 'package:facegen/page/canvas.dart';
import 'package:facegen/shared_prefs_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facegen/helper/sizehelper.dart';
import 'package:flutter/rendering.dart';
import 'package:facegen/helper/customdialog.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gallery_saver/gallery_saver.dart';
import '../main.dart';

class Generated extends StatefulWidget {
  File image;
  Generated({Key key, this.image}) : super(key: key);

  @override
  _GeneratedState createState() => _GeneratedState(image);
}

class _GeneratedState extends State<Generated> {

  String stringByte = "";
  Image generatedImage;

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
  File input;
  String _saveProgress = "";

  Uint8List generatedByte;

  Future<List<int>> descriptionList;

  _GeneratedState(File image) {
    this.input = image;
    setChosen();
    descriptionList = getDescriptionList();
  }


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
      request.files.add(
        http.MultipartFile(
          'image',
          input.readAsBytes().asStream(),
          input.lengthSync(),
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayWidth(context);
    MediaQuery
        .of(context)
        .padding
        .top - kToolbarHeight;

    // dev.log(descriptionList);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(w * 0.02, w * 0.08, w * 0.02, w * 0.08),
        child: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // buildFutureDropdown(w,h),
                buildCanvas(w, h),
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, w * 0.08, 0, w * 0.08),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          textColor: Colors.black,
                          color: Colors.grey,
                          child:
                          Text("1", style: TextStyle(fontSize: w * 0.05)),
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ), RaisedButton(
                          textColor: Colors.black,
                          color: Colors.grey,
                          child:
                          Text("2", style: TextStyle(fontSize: w * 0.05)),
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ), RaisedButton(
                          textColor: Colors.black,
                          color: Colors.grey,
                          child:
                          Text("3", style: TextStyle(fontSize: w * 0.05)),
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // buildDescription(w, h, context),
                buildButtons(w, context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> uint8ToFile(Uint8List imageInUnit8List, String number) async {
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/generated${number}.png').create();
    print('${tempDir.path}/generated${number}.png');
    file.writeAsBytesSync(imageInUnit8List);
    return ('${tempDir.path}/generated${number}.png');
  }

  FutureBuilder<List<int>> buildFutureDropdown(double h, double w) {
    dev.log("Build Canvas ");
    return FutureBuilder<List<int>>(
      future: getDescriptionList(),
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        print("[Debug] >>> Starting");
        if (snapshot.hasData) {
          print("[Debug] >>> " + snapshot.data.toString());
          // this.descriptionList = snapshot.data;
          // doUpload();
        } else {
          print("[Debug] >>> ERROR Retrieving");
        }

        print("[Debug] >>> Description List = " + descriptionList.toString());
        // return snapshot.hasData
        //     ? buildCanvas(w,h)
        //     : Container(
        //   child: Text("Test"),
        // );

        return buildCanvas(w, h);
      },
    );
  }

  Column buildCanvas(double w, double h) {
    return Column(
      children: [
        Text("Generated Face", style: TextStyle(fontSize: 20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: generatedImage != null
                    ? Container(
                  width: w * 0.95,
                  height: h * 0.95,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: generatedImage.image,
                      ),
                      border: Border.all(width: 1)),
                )
                    : Container(
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  width: w * 0.95,
                  height: h * 0.95,
                  //child:  _show(picture, context),
                )),
          ],
        ),
      ],
    );
  }

  Padding buildDescription(double w, double h, BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(h * 0.04, h * 0.02, h * 0.04, h * 0.02),
      child: Column(
        children: [
          Text("Descriptions", style: TextStyle(fontSize: 20)),
          Container(
            width: w * 0.95,
            height: h * 0.5,
            child: Padding(
                child: Scrollbar(
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
      ),
    );
  }

  Expanded buildButtons(double w, BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: w * 0.1,
              width: w * 0.75, // match_parent
              child: RaisedButton(
                  textColor: Colors.black,
                  color: Colors.blue,
                  child: Text("Edit Sketch or Description",
                      style: TextStyle(fontSize: w * 0.05)),
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => Canvas(image: input)),
                    // );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
            )
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.save_alt_outlined),
                splashColor: Colors.black,
                onPressed: () async {
                  File genFile;

                  uint8ToFile(generatedByte, "1").then((value) {
                    genFile = File(value);
                  });

                  if (genFile == null) return;
                  final Directory extDir = await getApplicationDocumentsDirectory();
                  String dirPath = extDir.path;

                  DateTime now = new DateTime.now();
                  DateTime date = new DateTime(
                      now.year, now.month, now.day, now.hour, now.minute, now.second);
                  final String fileName = basename("save${date.toString()}.png");
                  final File localImage = await genFile.copy('$dirPath/$fileName');


                  if (genFile != null && genFile.path != null) {
                    setState(() {
                      _saveProgress = 'saving in progress...';
                    });

                    GallerySaver.saveImage(genFile.path);
                    setState(() {
                      _saveProgress = 'Save Complelted...';
                    });
                    dev.log(_saveProgress);
                  }
                },
              ),

              IconButton(
                  onPressed: () =>
                      showDialog(
                        barrierColor: Colors.black26,
                        context: context,
                        builder: (context) {
                          return const CustomAlertDialog(
                            title: "Warning!",
                            description: "The created image will disappear\n" +
                                "Want to return to the main page?",
                          );
                        },
                      ),
                  icon: Icon(Icons.home_sharp))
            ],
          )
        ],
      ),
    );
  }

  void _takePhoto() async {
    File genFile;

    uint8ToFile(generatedByte, "1").then((value) {
      genFile = File(value);
    });

    if (genFile == null) return;
    final Directory extDir = await getApplicationDocumentsDirectory();
    String dirPath = extDir.path;

    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    final String fileName = basename("save${date.toString()}.png");
    final File localImage = await genFile.copy('$dirPath/$fileName');


    if (genFile != null && genFile.path != null) {
      setState(() {
        _saveProgress = 'saving in progress...';
      });

      GallerySaver.saveImage(genFile.path);
      setState(() {
        _saveProgress = 'Save Complelted...';
      });
      dev.log(_saveProgress);
    }
  }
}

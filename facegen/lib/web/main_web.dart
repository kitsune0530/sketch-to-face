import 'dart:io';

// import 'dart:html' as html;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;

import 'dart:typed_data';
import 'package:facegen/web/web_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker_web/image_picker_web.dart';
import 'package:painter/painter.dart';
import 'package:facegen/helper/sizehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:developer' as dev;
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import '../shared_prefs_helper.dart';
// import 'package:desktop_window/desktop_window.dart';
class MainWebsite extends StatefulWidget {
  const MainWebsite({Key? key}) : super(key: key);

  @override
  _MainWebsiteState createState() => _MainWebsiteState();
}

class _MainWebsiteState extends State<MainWebsite> {
  String gender = 'Male';
  String _choosenSkin = 'Light';
  String _choosenShape = 'Square/Triangle';
  String _choosenEyes = 'Monolid';
  String _choosenNose = 'Small';
  String _choosenMouth = 'Small';
  String _choosenEars = 'Hidden';
  String _choosenHair = 'None';
  String _choosenEyebrows = 'None';
  String _choosenBeard = 'None';

  List<String>? chooseList;

  void loadPreferences() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  double canvas = 128;

  // bool _finished = false;
  Image? imageFile;
  late Uint8List imageUint8;

  PainterController? _controllerBackup;

  final picker = ImagePicker();
  PainterController? _controller;

  @override
  void initState() {
    super.initState();
    // setWindowFrame(Rect.fromLTRB(1200.0, 500.0, 1800.0, 1125.0));

    loadPreferences();
    newPainterController();
    SharedPrefsHelper.resetValues();
  }

  // _MainWebsiteState(Image image) {
  //   if (image != null) {
  //     imageFile = image;
  //   } else {
  //     imageFile = null;
  //   }
  // }

  _MainWebsiteState() {
    // SharedPrefsHelper sharedPrefs = new SharedPrefsHelper();
    newPainterController();

    setChosen();
  }


  newPainterController() {
    _controller = new PainterController();
    // _controllerBackup = new PainterController();
    _controller!.thickness = 5.0;
    _controller!.backgroundColor = Colors.white;
  }

  String htmlSelectFileLog = "";

  _startFilePicker() async {
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    setState(() {
      imageFile = Image.memory(bytesFromPicker!);
      imageUint8 = bytesFromPicker;
    });
    dev.log("Save Image into \"imageFile\"");
  }

  double canvasSize = 128*3;

  @override
  Widget build(BuildContext context) {
    double realw = displayWidth(context);
    double realh = displayHeight(context);
    double w = displayWidth(context);
    double h = displayHeight(context);

    w = 1280;
    h = 800;

    // if(realh>realw){
    //   h = realw;
    //   w = realh;
    // }
    MediaQuery.of(context).padding.top - kToolbarHeight;
    dev.log(w.toString() + " " + h.toString());

    double pad = w * 0.01;
    double halfWidth;
    halfWidth = w * 0.5 - pad;
    double width = w - pad;
    double height = h - pad;

    size.setTitleFont(h * 0.04);
    size.setTextFont(h * 0.02);
    size.setPad(pad);
    size.setHalfWidth(halfWidth - pad * 10);
    size.setWidth(width - pad);
    size.setHeight(height - pad * 5);
    size.setW(w);
    size.setH(h);

    // canvasSize = (128*(size.getHalfWidth()/128).floor()) as double;
    canvasSize = size.getHalfWidth()-pad;




    return Scaffold(
      body: Padding(
        padding: new EdgeInsets.all(size.getPad()),
        child: Container(
          child: Scrollbar(
            child: ListView(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildBorderContainer(WebCanvas(w, h), pad),
                        buildBorderContainer(WebDropdown(w, h), pad),
                      ],
                    ),
                    SizedBox(
                      width: w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.all(pad),
                            width: pad * 10,
                            // height: pad * 2,
                            child: SizedBox(
                              // width: pad*5,
                              child: FlatButton(
                                minWidth: pad*5,
                                  onPressed: () {
                                    if (imageFile != null) {
                                      showImage(imageFile!, context, w);
                                    } else {
                                      setState(() {});
                                      // print(" >>> " + _controllerBackup.toString());
                                      // _controllerBackup = _controller;
                                      // print(" >>> " + _controllerBackup.toString());
                                      showDrawing(_controller!.finish(), context, w);
                                      // newPainterController();
                                    }
                                    setState(() {});
                                  },
                                  child: Text(
                                    "next",
                                    style: TextStyle(fontSize: size.getTitleFont()*0.8),
                                  ),
                                  color: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container WebCanvas(double w, double h) {
    return Container(
      width: size.getHalfWidth(),
      height: size.getHeight(),
      child: Column(
        children: [
          buildGenderButton(w, h),
          buildCanvasButton(w, h),
          buildCanvas(w, h),
        ],
      ),
    );
  }

  void showDrawing(PictureDetails picture, BuildContext dialogContext, w) {
    late Image image;
    showDialog(
      context: context,
      builder: (context) {
        dialogContext = context;
        return AlertDialog(
          actions: [
            FlatButton(
              minWidth: size.getPad() * 5,
              height: size.getPad() * 2,
              onPressed: () {
                // newPainterController();
                setState(() {
                });
                Navigator.of(context, rootNavigator: true).pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: size.getTitleFont()*0.8),
              ),
              color: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            FlatButton(
              minWidth: size.getPad() * 5,
              height: size.getPad() * 2,
              onPressed: () async {
                setState((){
                  // newPainterController();
                });
                SharedPreferences sharedPrefs =
                    await SharedPreferences.getInstance();
                sharedPrefs.setString("Gender", gender);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebSummary(
                      image: image,
                      imageUint8: imageUint8,
                    ),
                  ),
                );
              },
              child: Text(
                "Confirm",
                style: TextStyle(fontSize: size.getTitleFont()*0.8),
              ),
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10.0,
              ),
            ),
          ),
          title: Text(
            "Confirm Drawing",
            style: TextStyle(fontSize: size.getTitleFont()),
          ),
          content: Container(
            width: size.getHalfWidth(),
            height: size.getHeight()*0.7,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: FutureBuilder<Uint8List>(
                      future: picture.toPNG(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Uint8List> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            // String out;
                            imageUint8 = snapshot.data!;
                            image = Image.memory(snapshot.data!);
                            imageFile = image;

                            return Image.memory(snapshot.data!);
                          default:
                            return const FractionallySizedBox(
                              widthFactor: 0.1,
                              child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: CircularProgressIndicator()),
                              alignment: Alignment.center,
                            );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showImage(Image picture, BuildContext context, w) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            FlatButton(
              minWidth: size.getPad() * 5,
              height: size.getPad() * 2,
              onPressed: () {
                setState(() {
                // _controller = _controllerBackup;
                // newPainterController();
              });
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: size.getTitleFont()*0.8),
              ),
              color: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            FlatButton(
              minWidth: size.getPad() * 5,
              height: size.getPad() * 2,
              onPressed: () async {
                SharedPreferences sharedPrefs =
                    await SharedPreferences.getInstance();
                sharedPrefs.setString("Gender", gender ?? "");

                dev.log("[DEBUG] >>> ImageFile:" + imageFile.toString());
                dev.log("[DEBUG] >>> ImageUint8:" + imageUint8.toString());

                // Navigator.pop(context);
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebSummary(
                      image: imageFile,
                      imageUint8: imageUint8,
                    ),
                  ),
                );
                setState(() {});
              },
              child: Text(
                "Confirm",
                style: TextStyle(fontSize: size.getTitleFont()*0.8),
              ),
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10.0,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          title: Text(
            "Confirm Image",
            style: TextStyle(fontSize: size.getTitleFont()),
          ),
          content: Container(
            width: size.getHalfWidth(),
            height: size.getHeight()*0.7,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: picture.image,
                ),
                border: Border.all(width: 1)),
          ),
        );
      },
    );
  }

  Column buildGenderButton(double w, double h) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gender",
          style: TextStyle(
              fontSize: size.getTitleFont(),
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: EdgeInsets.only(top: size.getPad(), bottom: size.getPad()),
          child: Row(
            children: [
              Radio(
                value: 'Male',
                groupValue: gender,
                activeColor: Colors.blueAccent,
                onChanged: (value) {
                  setState(() {
                    gender = (value).toString();
                  });
                },
              ),
              Text('Male', style: TextStyle(fontSize: size.getTextFont())),
              Radio(
                value: 'Female',
                groupValue: gender,
                activeColor: Colors.pinkAccent,
                onChanged: (value) {
                  setState(() {
                    gender = (value).toString();
                  });
                },
              ),
              Text(
                'Female',
                style: TextStyle(fontSize: size.getTextFont()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column buildCanvasButton(double w, double h) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Text("Canvas",
                style: TextStyle(
                    fontSize: size.getTitleFont(), fontWeight: FontWeight.bold)),
            Text("(If unable to draw, press Clear Button)")
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.create),
                  tooltip: ' Brush',
                  onPressed: () {
                    setState(
                      () {
                        _controller?.eraseMode = false;
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.lens_outlined),
                  tooltip: 'Eraser',
                  onPressed: () {
                    setState(
                      () {
                        _controller?.eraseMode = true;
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.undo,
                  ),
                  tooltip: 'Undo',
                  onPressed: () {
                    bool isEmpt = _controller!.isEmpty;
                    if (isEmpt) {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) =>
                              const Text('Nothing to undo'));
                    } else {
                      _controller?.undo();
                    }
                  },
                ),
              ],
            ),
            buildSlider(),
            Row(
              children: <Widget>[
                // Text("select"),
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () {
                    _startFilePicker();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Clear',
                  onPressed: () {
                    newPainterController();
                    imageFile = null;
                    setState(() {});
                  },
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  SizedBox buildCanvas(double w, double h) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: imageFile != null
                ? Container(
                    width: canvasSize,
                    height: canvasSize,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageFile!.image,
                        ),
                        border: Border.all(width: 1)),
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                    ),
                    width: canvasSize,
                    height: canvasSize,
                    child: AspectRatio(
                        aspectRatio: 1 / 1, child: Painter(_controller!)),
                  ),
          ),
        ],
      ),
    );
  }

  Row buildSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Slider(
          value: _controller!.thickness,
          onChanged: (double value) => setState(() {
            _controller?.thickness = value;
          }),
          min: 1.0,
          max: 20.0,
          activeColor: Colors.black12,
        ),
      ],
    );
  }

  Container WebDropdown(double w, double h) {
    return Container(
      width: size.getHalfWidth() - size.getPad(),
      height: size.getHeight(),
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            Text(
              "Description",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: size.getTitleFont(),
                  color: Colors.black),
            ),
          ]),
          Padding(
            padding:
                EdgeInsets.fromLTRB(w * 0.01, w * 0.01, w * 0.01, w * 0.01),
            child: Column(
              children: [
                buildFutureDropdown("Skin Color", skinList),
                buildFutureDropdown("Face Shape", shapeList),
                buildFutureDropdown("Eyes", eyesList),
                buildFutureDropdown("Nose", noseList),
                buildFutureDropdown("Mouth", mouthList),
                buildFutureDropdown("Ears", earsList),
                buildFutureDropdown("Hair", hairList),
                buildFutureDropdown("Eyebrows", eyebrowsList),
                buildFutureDropdown("Beard", beardList),
              ],
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<String> buildFutureDropdown(String name, List<String> list) {
    // dev.log("Build " + name + " using " + list.toString());
    return FutureBuilder<String>(
      future: SharedPrefsHelper.getValue(name),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // dev.log("[DEBUG] SnapShot : " + snapshot.hasData.toString());
        // dev.log("[DEBUG] SnapShot Data : " + snapshot.data);
        return snapshot.hasData
            ? buildDropdown(name, list, snapshot.data!)
            : Container();
      },
    );
  }

  Row buildDropdown(String name, List<String> list, String dropdownValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: size.getHalfWidth() / 4,
          child: Text(
            name,
            style: TextStyle(
              fontSize: size.getTextFont(),
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DropdownButton<String>(
          value: dropdownValue,
          style: TextStyle(
            fontSize: size.getTextFont(),
            color: Colors.black,
          ),
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: SizedBox(
                width: size.getHalfWidth() / 2,
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: size.getTextFont(),
                  ),
                ),
              ),
            );
          }).toList(),
          hint: Text(
            "Please Select",
            style: TextStyle(
              fontSize: size.getTextFont(),
              color: Colors.black,
            ),
          ),
          onChanged: (newValue) async {
            SharedPreferences sharedPrefs =
                await SharedPreferences.getInstance();
            setState(() {
              dropdownValue = newValue!;
              sharedPrefs.setString(name, newValue);
              dropdownValue = sharedPrefs.getString(name)!;
              setChosen();
            });
          },
        )
      ],
    );
  }

  void setChosen() async {
    // List<String> desType = [
    //   "Skin Color",
    //   "Face Shape",
    //   "Eyes",
    //   "Nose",
    //   "Mouth",
    //   "Ears",
    //   "Hair",
    //   "Eyebrows",
    //   "Beard"
    // ];
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    List<String> defaultDes = [
      'Male',
      'Light',
      'Square/Triangle',
      'Monolid',
      'Small',
      'Small',
      'Hidden',
      'None',
      'None',
      'None'
    ];
    setState(() {
      gender = sharedPrefs.getString("Gender" ?? defaultDes[0])!;
      _choosenSkin = sharedPrefs.getString("Skin Color" ?? defaultDes[1])!;
      _choosenShape = sharedPrefs.getString("Face Shape" ?? defaultDes[2])!;
      _choosenEyes = sharedPrefs.getString("Eyes" ?? defaultDes[3])!;
      _choosenNose = sharedPrefs.getString("Nose" ?? defaultDes[4])!;
      _choosenMouth = sharedPrefs.getString("Mouth" ?? defaultDes[5])!;
      _choosenEars = sharedPrefs.getString("Ears" ?? defaultDes[6])!;
      _choosenHair = sharedPrefs.getString("Hair" ?? defaultDes[7])!;
      _choosenEyebrows = sharedPrefs.getString("Eyebrows" ?? defaultDes[8])!;
      _choosenBeard = sharedPrefs.getString("Beard" ?? defaultDes[9])!;
      // print(defaultDes[6]);
    });
    chooseList = [
      gender,
      _choosenSkin,
      _choosenShape,
      _choosenEyes,
      _choosenNose,
      _choosenMouth,
      _choosenEars,
      _choosenHair,
      _choosenEyebrows,
      _choosenBeard
    ];
    // print("0 : " + chooseList.toString());
  }
}

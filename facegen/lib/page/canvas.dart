// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:facegen/page/dropdown.dart';
import 'package:facegen/page/main_mobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_draw/flutter_draw.dart';
import 'package:image_picker/image_picker.dart';
import 'package:painter/painter.dart';
import 'package:facegen/helper/sizehelper.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Canvas extends StatefulWidget {
  File image;
  Canvas({Key key, this.image}) : super(key: key);

  @override
  _CanvasState createState() => _CanvasState(image);
}

class _CanvasState extends State<Canvas> {
  void loadPreferences() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  String gender = 'Male';
  bool _finished = false;
  File imageFile;

  PainterController _controllerBackup;

  final picker = ImagePicker();
  PainterController _controller;

  _CanvasState(File image) {
    if (image != null) {
      this.imageFile = image;
    } else {
      this.imageFile = null;
    }

    newPainterController();
  }
  void newPainterController() {
    _controller = new PainterController();
    _controller.thickness = 5.0;
    _controller.backgroundColor = Colors.white;
  }

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  choosenGallery() async {
    final pickerFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickerFile.path);
    });
  }

  choosenCamera() async {
    final pickerFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(pickerFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context);
    MediaQuery.of(context).size.height - kToolbarHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: buildBottomAppBar(w, context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                buildGenderButton(w, h),
                buildCanvasButton(h),
                buildCanvas(w, h),
                buildSlider()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> uint8ToFile(Uint8List imageInUnit8List) async {
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/drawing.png').create();
    print('${tempDir.path}/drawing.png');
    file.writeAsBytesSync(imageInUnit8List);
    return ('${tempDir.path}/drawing.png');
  }

  void showDrawing(PictureDetails picture, BuildContext dialogContext, w) {
    File image;
    showDialog(
      context: context,
      builder: (context) {
        dialogContext = context;
        return AlertDialog(
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(context);
                setState(() {
                  _controller = _controllerBackup;
                  // _finished = false;
                });
              },
              child: Text("Cancel"),
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            FlatButton(
              onPressed: () async {
                SharedPreferences sharedPrefs =
                    await SharedPreferences.getInstance();
                sharedPrefs.setString("Gender", gender ?? "");

                // Navigator.of(context, rootNavigator: true).pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DropdownPage(image: image),
                  ),
                );
                // Navigator.of(context, rootNavigator: true).pop(context);
                setState(() {
                  // _finished = true;
                });
              },
              child: Text("Confirm"),
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10.0,
              ),
            ),
          ),
          title: Text(
            "Confirm Drawing",
            style: TextStyle(fontSize: 20.0),
          ),
          content: Container(
            height: w * 0.9,
            width: w * 0.9,
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
                              return new Text('Error: ${snapshot.error}');
                            }
                            String out;

                            uint8ToFile(snapshot.data).then((value) {
                              out = value;
                              print("Out: " + out);
                              image = File(out);
                            });

                            return Image.memory(snapshot.data);
                          default:
                            return Container(
                              child: FractionallySizedBox(
                                widthFactor: 0.1,
                                child: AspectRatio(
                                    aspectRatio: 1.0,
                                    child: CircularProgressIndicator()),
                                alignment: Alignment.center,
                              ),
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

  void showImage(File picture, BuildContext context, w) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                setState(() {});
              },
              child: Text("Cancel"),
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            FlatButton(
              onPressed: () async {
                SharedPreferences sharedPrefs =
                    await SharedPreferences.getInstance();
                sharedPrefs.setString("Gender", gender ?? "");

                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DropdownPage(image: imageFile),
                  ),
                );
                setState(() {});
              },
              child: Text("Confirm"),
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10.0,
              ),
            ),
          ),
          contentPadding: EdgeInsets.only(
            top: 10.0,
          ),
          title: Text(
            "Confirm Drawing",
            style: TextStyle(fontSize: 24.0),
          ),
          content: Container(
            width: w * 0.9,
            height: w * 0.9,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(picture),
                ),
                border: Border.all(width: 1)),
          ),
        );
      },
    );
  }

  Container buildGenderButton(double w, double h) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gender",
            style: TextStyle(fontSize: h * 0.03, color: Colors.black),
          ),
          Row(
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
              const Text('Male'),
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
              const Text('Female'),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox buildCanvasButton(double h) {
    return SizedBox(
      // width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Canvas", style: TextStyle(fontSize: h * 0.03)),
          Row(
            children: <Widget>[
              // Text("select"),
              IconButton(
                icon: Icon(Icons.photo),
                onPressed: () {
                  choosenGallery();
                },
              ),
              IconButton(
                icon: Icon(Icons.camera),
                onPressed: () {
                  choosenCamera();
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh),
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
                    width: w * 0.95,
                    height: w * 0.95,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(imageFile),
                        ),
                        border: Border.all(width: 1)),
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                    ),
                    // width: 128 * ((w / 128).floor()).toDouble(),
                    // height: 128 * ((w / 128).floor()).toDouble(),
                    width: w * 0.95,
                    height: w * 0.95,
                    child: AspectRatio(
                        aspectRatio: 1 / 1, child: Painter(_controller)),
                  ),
          ),
        ],
      ),
    );
  }

  Container buildSlider() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Slider(
            value: _controller.thickness,
            onChanged: (double value) => setState(() {
              _controller.thickness = value;
            }),
            min: 1.0,
            max: 20.0,
            activeColor: Colors.black12,
          ),
        ],
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
                  //   MaterialPageRoute(builder: (context) => MainMenu()),
                  // );
                  Navigator.pop(context);
                },
                child: Text("back"),
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
          ),
          IconButton(
            icon: Icon(Icons.create),
            tooltip: ' draw',
            onPressed: () {
              setState(
                () {
                  _controller.eraseMode = false;
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.remove_circle),
            tooltip:
                (_controller.eraseMode ? 'Disable' : 'Disable') + ' eraser',
            onPressed: () {
              setState(
                () {
                  _controller.eraseMode = true;
                },
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.undo,
            ),
            tooltip: 'Undo',
            onPressed: () {
              if (_controller.isEmpty) {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) => Text('Nothing to undo'));
              } else {
                _controller.undo();
              }
            },
          ),
          SizedBox(
            width: w * 0.2,
            child: FlatButton(
                onPressed: () {
                  if (imageFile != null) {
                    showImage(imageFile, context, w);
                  } else {
                    print(" >>> "+_controllerBackup.toString());
                    _controllerBackup = _controller;
                    print(" >>> "+_controllerBackup.toString());
                    showDrawing(_controller.finish(), context, w);
                  }
                  setState(() {});
                },
                child: Text("next"),
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
          ),
        ],
      ),
    );
  }
}

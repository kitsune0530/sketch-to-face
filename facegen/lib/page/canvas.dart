import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:facegen/page/dropdown.dart';
import 'package:facegen/page/lobby.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_draw/flutter_draw.dart';
import 'package:image_picker/image_picker.dart';
import 'package:painter/painter.dart';
import 'package:facegen/helper/sizehelper.dart';

class Canvas extends StatefulWidget {
  const Canvas({Key key}) : super(key: key);

  @override
  _CanvasState createState() => _CanvasState();
}

class _CanvasState extends State<Canvas> {
  String gender = 'male';

  bool _finished = false;
  PainterController _controller = _newController();

  File imageFile;
  final picker = ImagePicker();

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
  void initState() {
    super.initState();
  }

  static PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.white;
    return controller;
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
            child: ListView(
              children: <Widget>[
                buildGenderButton(w),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Lobby()),
                  );
                },
                child: Text("back"),
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
          ),
          SizedBox(
              child: IconButton(
                  icon: Icon(Icons.create),
                  tooltip: ' draw',
                  onPressed: () {
                    setState(() {
                      _controller.eraseMode = false;
                    });
                  })),
          SizedBox(
              child: IconButton(
                  icon: Icon(Icons.remove_circle),
                  tooltip: (_controller.eraseMode ? 'Disable' : 'Disable') +
                      ' eraser',
                  onPressed: () {
                    setState(() {
                      _controller.eraseMode = true;
                    });
                  })),
          SizedBox(
            child: IconButton(
                icon: Icon(
                  Icons.undo,
                ),
                tooltip: 'Undo',
                onPressed: () {
                  if (_controller.isEmpty) {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) =>
                        new Text('Nothing to undo'));
                  } else {
                    _controller.undo();
                  }
                }),
          ),
          SizedBox(
            width: w * 0.2,
            child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DropdownPage(gender: gender, image: imageFile)),
                  );
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

  Container buildGenderButton(double w) {
    return Container(
                // height: h * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: const <Widget>[
                            Text(
                              "Gender",
                              style: TextStyle(
                                  // fontSize: h * 0.03,
                                  color: Colors.black),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  SizedBox(
                                    width: w * 0.1,
                                    child: Radio(
                                      value: 'male',
                                      groupValue: gender,
                                      activeColor: Colors.blueAccent,
                                      onChanged: (value) {
                                        setState(() {
                                          gender = (value).toString();
                                        });
                                      },
                                    ),
                                  ),
                                  const Text('Male')
                                ]),
                                Row(children: [
                                  SizedBox(
                                    width: w * 0.1,
                                    child: Radio(
                                      value: 'female',
                                      groupValue: gender,
                                      activeColor: Colors.pinkAccent,
                                      onChanged: (value) {
                                        setState(() {
                                          gender = (value).toString();
                                        });
                                      },
                                    ),
                                  ),
                                  const Text('Female')
                                ]),
                              ],
                            ),
                          ],
                        ),
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
                    Row(children: <Widget>[
                      Text("Canvas", style: TextStyle(fontSize: h * 0.03))
                    ]),
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
                          onPressed: _controller.clear,
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
                      width: 128 * w / 2,
                      height: 128 * h / 2,
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
                      width: 128 * ((w / 128).floor()).toDouble(),
                      height: 128 * ((w / 128).floor()).toDouble(),
                      child: AspectRatio(
                          aspectRatio: 1 / 1, child: Painter(_controller)),
                    )),
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
}

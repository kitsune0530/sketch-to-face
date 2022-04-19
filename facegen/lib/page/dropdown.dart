import 'dart:developer' as dev;
import 'dart:math';

import 'package:facegen/page/canvas.dart';
import 'package:facegen/page/summary.dart';
import 'package:facegen/page/lobby.dart';
import 'package:facegen/helper/sizehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facegen/page/canvas.dart';
import 'package:flutter_draw/painter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class DropdownPage extends StatefulWidget {
  String gender;
  File image;

  DropdownPage({Key key, this.gender, this.image}) : super(key: key);

  @override
  _DropdownPageState createState() => _DropdownPageState(image);
}

class _DropdownPageState extends State<DropdownPage> {
  String _choosenSkin;
  String _choosenShape;
  String _choosenEyes;
  String _choosenEyelids;
  String _choosenNose;
  String _choosenMouth;
  String _choosenEars;
  String _choosenHair;
  String _choosenEyebrows;
  String _choosenBeard;

  List<String> skin = [
    'Light',
    'Fair',
    'Medium',
    'Brown',
    'DarkBrown',
    'Black',
  ];
  List<String> shape = [
    'Square',
    'Round',
    'Oblong',
    'Oval',
    'Rectangle',
    'Diamond',
    'Heart'
  ];
  List<String> eyes = [
    'Small',
    'Medium',
    'Large',
    'Wide Set',
    'Close Set',
    'Downturned',
    'Upturned'
  ];
  List<String> eyelids = [
    'Single',
    'Small Crease',
    'Tapered Crease',
    'Parallel Crease',
    'High Crease',
  ];
  List<String> nose = [
    'Small',
    'Medium',
    'Large',
    'Narrow',
    'Wide',
  ];
  List<String> mouth = [
    'Small',
    'Wide',
    'Thin',
    'Heart Shape',
    'Heavy Upper',
    'Heavy Lower'
  ];
  List<String> ears = ['Small', 'Medium', 'Large', 'Square', 'Narrow', 'Round'];
  List<String> hair = [
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
  List<String> eyebrows = ['Straight', 'Flat', 'Rounded', 'Arched', 'S-shape'];
  List<String> beard = ['None', 'Short', 'Medium', 'Long'];

  File image;
  _DropdownPageState(File image) {
    this.image = image;
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context);
    MediaQuery.of(context).padding.top - kToolbarHeight;
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: buildBottomAppBar(w, context),
        body: Padding(
          padding: EdgeInsets.fromLTRB(w * 0.02, w * 0.02, w * 0.005, w * 0.02),
          child: SafeArea(
              child: Container(
            child: ListView(
              children: <Widget>[
                Row(children: const <Widget>[
                  Text(
                    "Characters",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ]),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      w * 0.03, w * 0.008, w * 0.008, w * 0.01),
                  child: Column(
                    children: <Widget>[
                      buildDropdown(h, w, "Skin Color", skin, _choosenSkin),
                      buildDropdown(h, w, "Face Shape", shape, _choosenShape),
                      buildDropdown(h, w, "Eyes", eyes, _choosenEyes),
                      buildDropdown(h, w, "Nose", nose, _choosenNose),
                      buildDropdown(h, w, "Mouth", mouth, _choosenMouth),
                      buildDropdown(h, w, "Ears", ears, _choosenEars),
                      buildDropdown(h, w, "Hair", hair, _choosenHair),
                      buildDropdown(
                          h, w, "Eyebrows", eyebrows, _choosenEyebrows),
                      buildDropdown(h, w, "Beard", beard, _choosenBeard),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ));
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
                    MaterialPageRoute(builder: (context) => Canvas()),
                  );
                },
                child: Text("back"),
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
          ),
          SizedBox(
            width: w * 0.2,
            child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SummaryPage(
                            image: widget.image,
                            gender: "${widget.gender}",
                            choosenSkin: checknull("$_choosenSkin"),
                            choosenShape: checknull("$_choosenShape"),
                            choosenEyes: checknull("$_choosenEyes"),
                            choosenEyelids: checknull("$_choosenEyelids"),
                            choosenNose: checknull("$_choosenNose"),
                            choosenMouth: checknull("$_choosenMouth"),
                            choosenEars: checknull("$_choosenEars"),
                            choosenHair: checknull("$_choosenHair"),
                            choosenEyebrows: checknull("$_choosenEyebrows"),
                            choosenBeard: checknull("$_choosenBeard"))),
                  );
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

  Row buildDropdown(
      double h, double w, String name, List<String> list, String index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        // SizedBox(width: w * 0.1),
        SizedBox(
          width: w * 0.6,
          child: DropdownButton<String>(
            value: index,
            style: const TextStyle(
              color: Colors.black,
            ),
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: const Text(
              "Please Select",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onChanged: (value) {
              dev.log(name + " list : " + list.toString());
              dev.log(name + " value : " + value);
              dev.log(name + " index : " + index);
              setState(() {
                index = value;
              });
            },
          ),
        )
      ],
    );
  }
}

String checknull(String charect) {
  if (charect.length == 4 && charect.toString() == 'null') {
    charect = " ";
  }
  return charect;
}

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

  DropdownPage({Key key, this.gender,  this.image}) : super(key: key);

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

  File image;
  _DropdownPageState(File image){
    this.image = image;
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context);
    MediaQuery.of(context).padding.top - kToolbarHeight;
    return Scaffold(
        backgroundColor: Colors.white,
        body:
        Padding(
          padding: EdgeInsets.fromLTRB(w*0.02, w*0.02, w*0.005, w*0.02),
          child: SafeArea(
            child:Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                      SizedBox(
                        width: 80,
                        child: FlatButton(onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Lobby()),
                          );
                        }, child: Text("cancel"), color: Colors.grey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                    ),]),
                    Row(children: <Widget>[Text("Charecters", style: TextStyle(fontSize: h*0.04, color: Colors.black),),]),
                    Padding(
                      padding: EdgeInsets.fromLTRB(w*0.03, w*0.008, w*0.008, w*0.01),
                      child: Column(
                        children: <Widget>[
                          buildSkin(h, w),
                          buildShape(h, w),
                          buildEyes(h, w),
                          buildEyelids(h, w),
                          buildNose(h, w),
                          buildMouth(h, w),
                          buildEars(h, w),
                          buildHair(h, w),
                          buildEyebrows(h, w),
                          buildBeard(h, w),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                      SizedBox(
                        width: w*0.2,
                        child: FlatButton(onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Canvas()),
                          );
                        }, child: Text("back"), color: Colors.grey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                      ),
                      SizedBox(
                        width: w*0.2,
                        child: FlatButton(onPressed: (){
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => SummaryPage(image: widget.image,gender: "${widget.gender}", choosenSkin: checknull("$_choosenSkin"),
                                 choosenShape: checknull("$_choosenShape"), choosenEyes: checknull("$_choosenEyes"), choosenEyelids: checknull("$_choosenEyelids"),
                                 choosenNose: checknull("$_choosenNose"), choosenMouth: checknull("$_choosenMouth"), choosenEars: checknull("$_choosenEars"),
                                 choosenHair: checknull("$_choosenHair"), choosenEyebrows: checknull("$_choosenEyebrows"), choosenBeard: checknull("$_choosenBeard"))),
                           );
                        }, child: Text("next"), color: Colors.grey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                      ),
                    ],)
                  ],
              ),
            )
          ),
        )
    );
  }

  Row buildBeard(double h, double w) {
    return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Beard', style: TextStyle(color: Colors.black, fontSize: h*0.02)),
                            SizedBox( width: w*0.1),
                            SizedBox( width: w*0.6,
                            child: DropdownButton<String>(
                              value: _choosenBeard,
                              style: TextStyle(color: Colors.black),
                              items: <String>[
                                'None',
                                'Short',
                                'Medium',
                                'Long'

                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: Text(
                                "Please choose a Beard",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:h*0.02,
                                    fontWeight: FontWeight.w600),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _choosenBeard = value;
                                });
                              },
                            ),),
                          ],
                        );
  }

  Row buildEyebrows(double h, double w) {
    return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Eyebrows', style: TextStyle(color: Colors.black, fontSize: h*0.02)),
                            SizedBox( width: w*0.1),
                            SizedBox( width: w*0.6,
                            child: DropdownButton<String>(
                              value: _choosenEyebrows,
                              style: TextStyle(color: Colors.black),
                              items: <String>[
                                'Straight',
                                'Flat',
                                'Rounded',
                                'Arched',
                                'S-shape'

                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint:  Text(
                                "Please choose a Eyebrows",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:h*0.02,
                                    fontWeight: FontWeight.w600),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _choosenEyebrows = value;
                                });
                              },
                            ),),
                          ],
                        );
  }

  Row buildHair(double h, double w) {
    return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Hair', style: TextStyle(color: Colors.black, fontSize: h*0.02)),
                            SizedBox( width: w*0.1),
                            SizedBox( width: w*0.6,
                            child: DropdownButton<String>(
                              value: _choosenHair,
                              style: TextStyle(color: Colors.black),
                              items: <String>[
                                'None',
                                'Straight-short',
                                'Straight-long',
                                'Wave-short',
                                'Wave-long',
                                'Curl-short',
                                'Curl-long',
                                'Coiled-short',
                                'Coiled-long',

                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: Text(
                                "Please choose a Hair",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:h*0.02,
                                    fontWeight: FontWeight.w600),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _choosenHair = value;
                                });
                              },
                            ),)
                          ],
                        );
  }

  Row buildEars(double h, double w) {
    return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Ears', style: TextStyle(color: Colors.black, fontSize: h*0.02)),
                            SizedBox( width: w*0.1),
                            SizedBox( width: w*0.6,
                            child: DropdownButton<String>(
                              value: _choosenEars,
                              style: TextStyle(color: Colors.black),
                              items: <String>[
                                'Small',
                                'Medium',
                                'Large',
                                'Square',
                                'Narrow',
                                'Round'

                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: Text(
                                "Please choose a Ears",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:h*0.02,
                                    fontWeight: FontWeight.w600),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _choosenEars = value;
                                });
                              },
                            ),),
                          ],
                        );
  }

  Row buildMouth(double h, double w) {
    return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Mouth', style: TextStyle(color: Colors.black, fontSize: h*0.02)),
                            SizedBox( width: w*0.1),
                            SizedBox(width: w*0.6,
                            child: DropdownButton<String>(
                              value: _choosenMouth,
                              style: TextStyle(color: Colors.black),
                              items: <String>[
                                'Small',
                                'Wide',
                                'Thin',
                                'Heart Shape',
                                'Heavy Upper',
                                'Heavy Lower'

                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: Text(
                                "Please choose a Mouth",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:h*0.02,
                                    fontWeight: FontWeight.w600),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _choosenMouth = value;
                                });
                              },
                            ),),
                          ],
                        );
  }

  Row buildNose(double h, double w) {
    return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Nose', style: TextStyle(color: Colors.black, fontSize: h*0.02)),
                            SizedBox( width: w*0.1),
                            SizedBox( width: w*0.6,
                              child: DropdownButton<String>(
                                value: _choosenNose,
                                style: TextStyle(color: Colors.black),
                                items: <String>[
                                  'Small',
                                  'Medium',
                                  'Large',
                                  'Narrow',
                                  'Wide',

                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: Text(
                                  "Please choose a Nose",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize:h*0.02,
                                      fontWeight: FontWeight.w600),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _choosenNose = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        );
  }

  Row buildEyelids(double h, double w) {
    return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Eyelids', style: TextStyle(color: Colors.black, fontSize: h*0.02)),
                            SizedBox( width: w*0.1),
                            SizedBox( width: w*0.6,
                              child: DropdownButton<String>(
                                value: _choosenEyelids,
                                style: TextStyle(color: Colors.black),
                                items: <String>[
                                  'Single',
                                  'Small Crease',
                                  'Tapered Crease',
                                  'Parallel Crease',
                                  'High Crease',

                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: Text(
                                  "Please choose a Eyelids",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: h*0.02,
                                      fontWeight: FontWeight.w600),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _choosenEyelids = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        );
  }

  Row buildEyes(double h, double w) {
    return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Eyes', style: TextStyle(color: Colors.black, fontSize: h*0.02)),
                            SizedBox( width: w*0.1),
                            SizedBox(width: w*0.6,
                            child: DropdownButton<String>(
                              value: _choosenEyes,
                              style: TextStyle(color: Colors.black),
                              items: <String>[
                                'Small',
                                'Medium',
                                'Large',
                                'Wide Set',
                                'Close Set',
                                'Downturned',
                                'Upturned'

                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: Text(
                                "Please choose a Eyes",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: h*0.02,
                                    fontWeight: FontWeight.w600),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _choosenEyes = value;
                                });
                              },
                            ),)
                          ],
                        );
  }

  Row buildShape(double h, double w) {
    return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Shape', style: TextStyle(color: Colors.black, fontSize: h*0.02)),
                            SizedBox( width: w*0.1),
                            SizedBox( width: w*0.6,
                              child: DropdownButton<String>(
                                value: _choosenShape,
                                style: TextStyle(color: Colors.black),
                                items: <String>[
                                  'Square',
                                  'Round',
                                  'Oblong',
                                  'Oval',
                                  'Rectangle',
                                  'Diamond',
                                  'Heart'

                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: Text(
                                  "Please choose a Face Shape",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize:h*0.02,
                                      fontWeight: FontWeight.w600),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _choosenShape = value;
                                  });
                                },
                              ),
                            )
                          ],
                        );
  }

  Row buildSkin(double h, double w) {
    return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Skin Color', style: TextStyle(color: Colors.black, fontSize: h*0.02)),
                            SizedBox( width: w*0.1),
                            SizedBox( width: w*0.6,
                              child: DropdownButton<String>(
                                value: _choosenSkin,
                                style: TextStyle(color: Colors.black),
                                items: <String>[
                                  'Light',
                                  'Fair',
                                  'Medium',
                                  'Brown',
                                  'DarkBrown',
                                  'Black',

                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: Text(
                                  "Please choose a Skin Color",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: h*0.02,
                                      fontWeight: FontWeight.w600),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _choosenSkin = value;
                                  });
                                },
                              ),
                            )
                          ],
                        );
  }
}

String checknull(String charect){
  if(charect.length == 4 && charect.toString() == 'null'){ charect = " ";}
  return charect;
}

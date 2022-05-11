import 'dart:developer' as dev;
import 'dart:math';

import 'package:facegen/page/canvas.dart';
import 'package:facegen/page/summary.dart';
import 'package:facegen/page/main_mobile.dart';
import 'package:facegen/helper/sizehelper.dart';
import 'package:facegen/sizing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facegen/page/canvas.dart';
// import 'package:flutter_draw/painter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../shared_prefs_helper.dart';

class DropdownPage extends StatefulWidget {
  File image;

  DropdownPage({Key? key, required this.image}) : super(key: key);

  // void initState() {
  //   image=null;
  // }

  @override
  _DropdownPageState createState() => _DropdownPageState(image);
}

class _DropdownPageState extends State<DropdownPage> {

  String? _choosenSkin;
  String? _choosenShape;
  String? _choosenEyes;
  String? _choosenNose;
  String? _choosenMouth;
  String? _choosenEars;
  String? _choosenHair;
  String? _choosenEyebrows;
  String? _choosenBeard;

  String? gender;
  late File image;

  // Future<List<String>> chooseList;
  List<String>? chooseList;




  _DropdownPageState(this.image) {
    dev.log("[DEBUG] >>> Dropdown Image recieve:" +this.image.toString());
    setChosen();
  }

  // ContextSize size = new ContextSize();

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context);
    MediaQuery.of(context).padding.top - kToolbarHeight;
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: buildBottomAppBar(w, context),
        body: Padding(
          padding:EdgeInsets.all(size.getPad()),
          child: SafeArea(
              child: Container(
            child: ListView(
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



                // Container(
                //   child: image != null
                //       ? Container(
                //     width: size.getWidth(),
                //     height: size.getWidth(),
                //     decoration: BoxDecoration(
                //         image: DecorationImage(
                //           image: FileImage(image),
                //         ),
                //         border: Border.all(width: 1)),
                //   )
                //       : Container(
                //     decoration: BoxDecoration(border: Border.all(width: 1)),
                //     width: size.getWidth(),
                //     height: size.getWidth(),
                //     //child:  _show(picture, context),
                //   ),
                // ),



                Padding(
                  padding: EdgeInsets.fromLTRB(
                      size.getPad(), size.getPad(),size.getPad(), size.getPad()),
                  child: Column(
                    children: [
                      buildFutureDropdown(h, w, "Skin Color", skinList),
                      buildFutureDropdown(h, w, "Face Shape", shapeList),
                      buildFutureDropdown(h, w, "Eyes", eyesList),
                      buildFutureDropdown(h, w, "Nose", noseList),
                      buildFutureDropdown(h, w, "Mouth", mouthList),
                      buildFutureDropdown(h, w, "Ears", earsList),
                      buildFutureDropdown(h, w, "Hair", hairList),
                      buildFutureDropdown(h, w, "Eyebrows", eyebrowsList),
                      buildFutureDropdown(h, w, "Beard", beardList),
                      // buildDropdown(h, w, "Skin Color", skinList, _choosenSkin),
                      // buildDropdown(h, w, "Face Shape", shapeList),
                      // buildDropdown(h, w, "Eyes", eyesList),
                      // buildDropdown(h, w, "Nose", noseList),
                      // buildDropdown(h, w, "Mouth", mouthList),
                      // buildDropdown(h, w, "Ears", earsList),
                      // buildDropdown(h, w, "Hair", hairList),
                      // buildDropdown(
                      //     h, w, "Eyebrows", eyebrowsList),
                      // buildDropdown(h, w, "Beard", beardList),
                    ],
                  ),
                  //
                ),
              ],
            ),
          )),
        ));
  }

  FutureBuilder<String> buildFutureDropdown(
      double h, double w, String name, List<String> list) {
    // dev.log("Build " + name + " using " + list.toString());
    return FutureBuilder<String>(
      future: SharedPrefsHelper.getValue(name),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return snapshot.hasData
            ? buildDropdown(h, w, name, list, snapshot.data!)
            : Container();
      },
    );
  }

  BottomAppBar buildBottomAppBar(double w, BuildContext context) {
    return BottomAppBar(
      // color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(size.getPad()),
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
                    //       builder: (context) => Canvas(image: image)),
                    // );

                    Navigator.pop(context);
                  },
                  child: Text("back", style: TextStyle(fontSize: size.getTextFont()),),
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
            SizedBox(
              width: w * 0.2,
              child: FlatButton(
                  onPressed: () {

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => SummaryPage.setImage(
                    //       image: image,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Text("next", style: TextStyle(fontSize: size.getTextFont()),),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
          ],
        ),
      ),
    );
  }

  Row buildDropdown(double h, double w, String name, List<String> list,
      String? dropdownValue) {
    // print(dropdownValue);
    // String temp;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          width: size.getWidth()*0.3,
          child: Text(
            name,
            style: TextStyle(
              fontSize: size.getTextFont(),
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // SizedBox(width: w * 0.1),
        Container(
          width: size.getWidth()*0.6,
          child: DropdownButton<String>(
            value: dropdownValue,
            style:  TextStyle(
              fontSize: size.getTextFont()*0.8,
              color: Colors.black,
            ),
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text(
              "Please Select",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onChanged: (newValue) async {
              SharedPreferences sharedPrefs =
                  await SharedPreferences.getInstance();
              setState(() {
                dropdownValue = newValue!;
                sharedPrefs.setString(name, newValue);
                dropdownValue = sharedPrefs.getString(name);
                // dev.log("Value: " + dropdownValue);
                setChosen();
              });
            },
          ),
        )
      ],
    );
  }

  void setChosen() async {
    List<String> desType = [
      "Skin Color",
      "Face Shape",
      "Eyes",
      "Nose",
      "Mouth",
      "Ears",
      "Hair",
      "Eyebrows",
      "Beard"
    ];
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
      gender = sharedPrefs.getString("Gender" ?? defaultDes[0]);
      _choosenSkin = sharedPrefs.getString("Skin Color" ?? defaultDes[1]);
      _choosenShape = sharedPrefs.getString("Face Shape" ?? defaultDes[2]);
      _choosenEyes = sharedPrefs.getString("Eyes" ?? defaultDes[3]);
      _choosenNose = sharedPrefs.getString("Nose" ?? defaultDes[4]);
      _choosenMouth = sharedPrefs.getString("Mouth" ?? defaultDes[5]);
      _choosenEars = sharedPrefs.getString("Ears" ?? defaultDes[6]);
      _choosenHair = sharedPrefs.getString("Hair" ?? defaultDes[7]);
      _choosenEyebrows = sharedPrefs.getString("Eyebrows" ?? defaultDes[8]);
      _choosenBeard = sharedPrefs.getString("Beard" ?? defaultDes[9]);

      print(defaultDes[6]);
    });
    chooseList = [
      gender!,
      _choosenSkin!,
      _choosenShape!,
      _choosenEyes!,
      _choosenNose!,
      _choosenMouth!,
      _choosenEars!,
      _choosenHair!,
      _choosenEyebrows!,
      _choosenBeard!
    ];
    print("0 : " + chooseList.toString());
  }
}

String checkNull(String charCheck) {
  if (charCheck == null) {
    charCheck = "-";
  }
  return charCheck;
}

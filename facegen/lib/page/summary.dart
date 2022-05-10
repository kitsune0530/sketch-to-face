import 'dart:io';
import 'dart:typed_data';
import 'package:facegen/page/dropdown.dart';
import 'package:facegen/page/result.dart';
import 'package:facegen/helper/sizehelper.dart';
import 'package:facegen/sizing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_draw/painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SummaryPage extends StatefulWidget {
  File image;
  SummaryPage({
    Key key,
    this.image,
  }) : super(key: key);

  SummaryPage.setImage({
    Key key,
    this.image,
  }) : super(key: key);



  @override
  _SummaryPageState createState() => _SummaryPageState(image);
}

class _SummaryPageState extends State<SummaryPage> {
  bool _finished = false;
  // PainterController _controller;

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
  File image;

  File imageFile;
  final picker = ImagePicker();

  _SummaryPageState(File image) {
    print(" >>> Create Summary");
    this.image = null;
    print(" >>> Set Image =  null");
    this.image = image;
    print(" >>> Set New Image");

    setChoosed();

  }
  // _SummaryPageState.setImage(this.image){
  //
  //   setChoosed();
  // }
  // ContextSize size = new ContextSize();
  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayWidth(context);
    MediaQuery.of(context).padding.top - kToolbarHeight;

    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    double canvasSize = 0;

    if (isPortrait) {
      canvasSize = 128 * ((w / 128).floor()).toDouble();
    } else {
      canvasSize = 128 * ((h / 128).floor()).toDouble();
    }
    return Scaffold(
      bottomNavigationBar: buildBottomAppBar(w, context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(size.getPad()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Canvas", style: TextStyle(fontSize: size.getTitleFont())),
              buildSumCanvas(w, h, canvasSize),
              Padding(
                padding: EdgeInsets.only( top:size.getPad()),
                child: Text("Descriptions", style: TextStyle(fontSize: size.getTitleFont())),
              ),
              buildSumDescription(w, h),
            ],
          ),
        ),
      ),
    );
  }


  Row buildSumCanvas(double w, double h, double canvasSize) {
    print(" >>> Build Sum Canvas");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: image != null
              ? Container(
            width: w * 0.95,
            height: w * 0.95,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(image),
                ),
                border: Border.all(width: 1)),
          )
              : Container(
            decoration: BoxDecoration(border: Border.all(width: 1)),
            width: w * 0.95,
            height: w * 0.95,
            //child:  _show(picture, context),
          ),
        ),
      ],
    );
  }

  Expanded buildSumDescription(double w, double h) {
    return  Expanded(
      child: Container(
        width: size.getWidth(),
        // height: h * 0.3,
        child: Padding(
            padding: EdgeInsets.all(size.getPad()),
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
            )
        ),
      ),
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
                    //     builder: (context) => DropdownPage(
                    //       image: this.image,
                    //     ),
                    //   ),
                    // )
                    Navigator.pop(context);
                  },
                  child: Text("back", style: TextStyle(fontSize: size.getTextFont()),),
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
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
                      builder: (context) => Generated(image: this.image),
                    ),
                  );
                },
                child: Text("Generate", style: TextStyle(fontSize: size.getTextFont()),),
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }





  void _show(PictureDetails picture, BuildContext context) {
    setState(() {
      _finished = true;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('View your image'),
            ),
            body: Container(
              alignment: Alignment.center,
              child: FutureBuilder<Uint8List>(
                future: picture.toPNG(),
                builder:
                    (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Image.memory(snapshot.data);
                      }
                      break;
                    default:
                      return const FractionallySizedBox(
                        widthFactor: 0.1,
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: CircularProgressIndicator(),
                        ),
                        alignment: Alignment.center,
                      );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void setChoosed() async {

    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      // for (var i = 0; i < desType.length; i++) {
      //   desType[i] = sharedPrefs.getString(name ?? "");
      //   sharedPrefs.getString(name ?? "");
      // }

      // gender = sharedPrefs.getString(desType[0] ?? "");
      // _choosenSkin = sharedPrefs.getString("Skin Color" ?? "");
      // _choosenShape = sharedPrefs.getString("Face Shape" ?? "");
      // _choosenEyes = sharedPrefs.getString("Eyes" ?? "");
      // _choosenNose = sharedPrefs.getString("Nose" ?? "");
      // _choosenMouth = sharedPrefs.getString("Mouth" ?? "");
      // _choosenEars = sharedPrefs.getString("Ears" ?? "");
      // _choosenHair = sharedPrefs.getString("Hair" ?? "");
      // _choosenEyebrows = sharedPrefs.getString("Eyebrows" ?? "");
      // _choosenBeard = sharedPrefs.getString("Beard" ?? "");

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
}

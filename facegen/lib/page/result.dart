import 'dart:convert';
import 'dart:ui';

import 'package:facegen/page/canvas.dart';
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

class Generated extends StatefulWidget {
  String gender = '';
  String choosenSkin = '';
  String choosenShape = '';
  String choosenEyes = '';
  String choosenEyelids = '';
  String choosenNose = '';
  String choosenMouth = '';
  String choosenEars = '';
  String choosenHair = '';
  String choosenEyebrows = '';
  String choosenBeard = '';
  File image;
  Generated(
      {Key key,
      this.image,
      this.gender,
      this.choosenSkin,
      this.choosenShape,
      this.choosenEyes,
      this.choosenEyelids,
      this.choosenNose,
      this.choosenMouth,
      this.choosenEars,
      this.choosenHair,
      this.choosenEyebrows,
      this.choosenBeard})
      : super(key: key);

  @override
  _GeneratedState createState() => _GeneratedState();
}

class _GeneratedState extends State<Generated> {
  String stringByte = "";
  Image generatedImage;
  Future<dynamic> doUpload() async {
    try{
      var request = http.MultipartRequest(
        'POST',
        // Uri.parse("http://52.148.83.67:8086/generate"),
        Uri.parse("http://192.168.245.3:8086/generate"),
        // Uri.parse("http://192.168.88.220:8086/generate"),
      );
      Map<String, String> headers = {"Content-type": "multipart/form-data"};
      request.files.add(
        http.MultipartFile(
          'image',
          widget.image.readAsBytes().asStream(),
          widget.image.lengthSync(),
          filename: "filename",
          contentType: MediaType('image', 'png'),
        ),
      );
      request.headers.addAll(headers);
      print(">>>>>>>>>>>>>>>>>>>>>>>>request: " + request.toString());
      var response = await request.send();
      print(">>>>>>>>>>>>>>>>>>>>>>>>request: " + response.statusCode.toString());
      var resBytes = await response.stream.toBytes();

      generatedImage = Image.memory(resBytes.buffer.asUint8List());
      setState(() {});
    }catch(e){
      e.toString();
    }
    // return image;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doUpload();
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayWidth(context);
    MediaQuery.of(context).padding.top - kToolbarHeight;
    String headchar(String headch, String data) {
      String text = "";
      if (data.length != 1) {
        // String dat = data==null? '' : data;
        text = data + " " + headch;
      }
      return text;
    }
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(w * 0.02, w * 0.08, w * 0.02, w * 0.08),
        child: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: w * 0.05),
                Text("Generated Face", style: TextStyle(fontSize: h * 0.08)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: generatedImage != null
                            ? Container(
                                width: w * 0.95,
                                height: h * 0.6,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: generatedImage.image,
                                    ),
                                    border: Border.all(width: 1)),
                              )
                            : Container(
                                decoration:
                                    BoxDecoration(border: Border.all(width: 1)),
                                width: w * 0.95,
                                height: h * 0.6,
                                //child:  _show(picture, context),
                              )),
                  ],
                ),
                SizedBox(
                  height: h * 0.05,
                ),
                Text("Descriptions", style: TextStyle(fontSize: h * 0.08)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      width: w * 0.95,
                      height: h * 0.45,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            h * 0.04, h * 0.02, h * 0.04, h * 0.02),
                        child: Text(
                          "  ${widget.gender} ${headchar("skin", "${widget.choosenSkin}")} ${headchar("face shape", "${widget.choosenShape}")} "
                          "${headchar("eyes", "${widget.choosenEyes}")} ${headchar("eyelids", "${widget.choosenEyelids}")} ${headchar("nose", "${widget.choosenNose}")} "
                          "${headchar("mouth", "${widget.choosenMouth}")} ${headchar("ears", "${widget.choosenEars}")} ${headchar("hair", "${widget.choosenHair}")} "
                          "${headchar("eyebrows", "${widget.choosenEyebrows}")} ${headchar("beard", "${widget.choosenBeard}")}",
                          style: TextStyle(fontSize: h * 0.05),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: h * 0.05,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    height: w * 0.1,
                    width: w * 0.75, // match_parent
                    child: RaisedButton(
                        textColor: Colors.black,
                        color: Colors.grey,
                        child: Text("Edit sketch / description",
                            style: TextStyle(fontSize: w * 0.05)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Canvas()),
                          );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                  )
                ]),
                SizedBox(height: w * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.save_alt_outlined),
                      splashColor: Colors.black,
                      onPressed: () {},
                    ),
                    IconButton(
                        onPressed: () => showDialog(
                              barrierColor: Colors.black26,
                              context: context,
                              builder: (context) {
                                return CustomAlertDialog(
                                  title: "Warning!",
                                  description:
                                      "The created image will disappear\n" +
                                          "Want to return to the main page?",
                                );
                              },
                            ),
                        icon: Icon(Icons.home_sharp))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:facegen/page/dropdown.dart';
import 'package:facegen/page/result.dart';
import 'package:facegen/helper/sizehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_draw/painter.dart';
import 'package:image_picker/image_picker.dart';

class SummaryPage extends StatefulWidget {
  String gender;
  String choosenSkin;
  String choosenShape;
  String choosenEyes;
  String choosenEyelids;
  String choosenNose;
  String choosenMouth;
  String choosenEars;
  String choosenHair;
  String choosenEyebrows;
  String choosenBeard;
  File image;
  SummaryPage(
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
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  bool _finished = false;
  PainterController _controller;

  File imageFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayWidth(context);
    MediaQuery.of(context).padding.top - kToolbarHeight;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(w * 0.02, w * 0.08, w * 0.02, w * 0.08),
        child: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: w * 0.05),
                Text("Canvas", style: TextStyle(fontSize: h * 0.08)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: widget.image != null
                            ? Container(
                                width: w * 0.95,
                                height: h * 0.6,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(widget.image),
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
                SizedBox(height: w * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      width: w * 0.2,
                      child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DropdownPage(
                                  image: widget.image,
                                  gender: "${widget.gender}",
                                ),
                              ),
                            );
                          },
                          child: Text("back"),
                          color: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                    ),
                    SizedBox(
                      width: w * 0.4,
                      child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Generated(
                                        image: widget.image,gender: "${widget.gender}", choosenSkin: checknull(widget.choosenSkin),
                                  choosenShape: checknull(widget.choosenShape), choosenEyes: checknull(widget.choosenEyes), choosenEyelids: checknull(widget.choosenEyelids),
                                  choosenNose: checknull(widget.choosenNose), choosenMouth: checknull(widget.choosenMouth), choosenEars: checknull(widget.choosenEars),
                                  choosenHair: checknull(widget.choosenHair), choosenEyebrows: checknull(widget.choosenEyebrows), choosenBeard: checknull(widget.choosenBeard)
                                      )),
                            );
                          },
                          child: Text("Face Generate"),
                          color: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String headchar(String headch, String data) {
    String text = "";
    if (data.length != 1) {
      text = data + " " + headch;
    }
    return text;
  }

  void _show(PictureDetails picture, BuildContext context) {
    setState(() {
      _finished = true;
    });
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('View your image'),
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
                    return Container(
                        child: const FractionallySizedBox(
                      widthFactor: 0.1,
                      child: AspectRatio(
                          aspectRatio: 1.0, child: CircularProgressIndicator()),
                      alignment: Alignment.center,
                    ));
                }
              },
            )),
      );
    }));
  }
}

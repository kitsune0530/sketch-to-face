import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as dev;
import 'package:facegen/helper/customdialog.dart';
import 'package:http/http.dart' as http;
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:facegen/helper/sizehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:facegen/shared_prefs_helper.dart';
import 'package:flutter/rendering.dart';
import 'package:http_parser/http_parser.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../shared_prefs_helper.dart';

class WebSummary extends StatefulWidget {
  Image? image;
  Uint8List? imageUint8;
  WebSummary({Key? key, this.image, this.imageUint8}) : super(key: key);

  WebSummary.setImage({
    Key? key,
    this.image,
  }) : super(key: key);

  @override
  _WebSummaryState createState() => _WebSummaryState(image!, imageUint8!);
}

class _WebSummaryState extends State<WebSummary> {
  /*
  *
  *
  *
  *     Summary
  *
  *
  *
   */

  final WebImageDownloader _webImageDownloader = WebImageDownloader();
  File? genFile;
  String stringByte = "";
  Image? img1;
  Image? img2;
  Image? img3;

  List<Image>? generatedImage = List<Image>.empty(growable: true);
  List<Image>? generatedNoDesImage = List<Image>.empty(growable: true);

  Uint8List? uint8ListImage;

  List<Uint8List>? generatedByte;
  List<Uint8List>? generatedNoDesByte;

  int selectedNoDesIntex = 0;
  int selectedIntex = 0;

  String gender = '',
      _choosenSkin = '',
      _choosenShape = '',
      _choosenEyes = '',
      _choosenNose = '',
      _choosenMouth = '',
      _choosenEars = '',
      _choosenHair = '',
      _choosenEyebrows = '',
      _choosenBeard = '';
  // File? input;
  Image? input;
  String? _saveProgress = "";
  Uint8List temp = new Uint8List(1);
  final ScrollController controllerOne = ScrollController();
  final ScrollController controllerTwo = ScrollController();

  late Future<List<int?>> descriptionList;
  ScreenshotController firstController = new ScreenshotController();
  ScreenshotController secondController = new ScreenshotController();


  _WebSummaryState(Image image, Uint8List uint8list) {

    setChosen();
    generatedByte = List<Uint8List>.filled(3, temp, growable: true);
    generatedNoDesByte = List<Uint8List>.filled(3, temp, growable: true);

    uint8ListImage = uint8list;
    this.input = image;
    descriptionList = getDescriptionList();

    generatedNoDesImage?.add(input!);
    generatedNoDesImage?.add(input!);
    generatedNoDesImage?.add(input!);

    generatedImage?.add(input!);
    generatedImage?.add(input!);
    generatedImage?.add(input!);
    String? ImgLength = generatedImage?.length.toString();
    dev.log("[DEBUG] [Constructor] >>> GenerateImage Length : " + ImgLength!);

    getImage();
    getNoDesImage();
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
    for (var i = 0; i < sumsLength; i = i + 1) {
      String temp = await SharedPrefsHelper.getValue(desType[i]);
      int idx = sumsDes[i].indexWhere((element) => element == temp);
      tempList[i] = idx;
    }
    dev.log(" >>> End Loop ${i.toString()}");
    return tempList;
  }

  void getImage() async {
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
    for (var i = 0; i < sumsLength; i = i + 1) {
      String temp = await SharedPrefsHelper.getValue(desType[i]);
      int idx = sumsDes[i].indexWhere((element) => element == temp);
      tempList[i] = idx;
    }
    dev.log(" >>> End Loop ${i.toString()}");
    // dev.log("Index " " : " + descriptionList.toString());

    dev.log(" >>> Start Uploading");
    try {
      for (var i = 0; i < 3; i++) {
        dev.log("[DEBUG] >>> Upload Round: " + i.toString());

        var request = http.MultipartRequest(
          'POST',
          // Uri.parse("http://192.168.245.3:8086/generate"),
          // Uri.parse("http://52.148.83.67:8086/generate"),
          Uri.parse("http://10.160.131.121:8086/generate"),
        );

        Map<String, String> headers = {"Content-type": "multipart/form-data"};
        int length = 10;

        dev.log("[DEBUG] >>> Set Request Uri");

        for (var j = 0; j < length; j++) {
          request.fields[desType[j]] = tempList[j].toString();
        }

        dev.log("[DEBUG] >>> Set Field Uri ");

        Future<Uint8List> futureUint8(Uint8List uint8) async {
          return uint8;
        }

        Stream<Uint8List> stream =
            Stream<Uint8List>.fromFuture(futureUint8(uint8ListImage!));

        request.files.add(
          http.MultipartFile(
            'image',
            stream,
            uint8ListImage!.lengthInBytes,
            filename: "filename",
            contentType: MediaType('image', 'png'),
          ),
        );

        dev.log("[DEBUG] >>> Set File :" + request.files.toString());

        dev.log("[DEBUG] >>> Set Request File :" + request.files.toString());

        // dev.log(request.files.toString());
        dev.log(request.fields.toString());

        request.fields['randomIdx'] = i.toString();
        request.headers.addAll(headers);

        dev.log("[DEBUG] >>> Request Data: " + request.toString());
        var response = await request.send();
        dev.log("[DEBUG] >>> Response Code: " + response.statusCode.toString());
        var resBytes = await response.stream.toBytes();

        dev.log("[DEBUG] >>> Response: Get Stream.");

        generatedByte![i] = resBytes.buffer.asUint8List();
        dev.log("[DEBUG] >>> Convery Stream to Uint8List");
        generatedImage![i] = Image.memory(resBytes.buffer.asUint8List());
        // generatedImage?.add(Image.memory(resBytes.buffer.asUint8List())) ;
        dev.log("[DEBUG] >>> Save Image into List.");
        setState(() {});
        await Future.delayed(Duration(seconds: 1));
      }
    } catch (e) {
      dev.log(" >>> Exception Uploading");
      dev.log(e.toString());
    }
  }

  void getNoDesImage() async {
    try {
      for (var i = 0; i < 3; i++) {
        var request = http.MultipartRequest(
          'POST',
          // Uri.parse("http://192.168.245.3:8086/generate"),
          // Uri.parse("http://52.148.83.67:8086/generate_no_des"),
          Uri.parse("http://10.160.131.121:8086/generate_no_des"),
        );

        Map<String, String> headers = {"Content-type": "multipart/form-data"};
        int length = 10;

        dev.log("[DEBUG] >>> Set Request Uri");

        // dev.log("[DEBUG] >>> Set Field Uri ");

        Future<Uint8List> futureUint8(Uint8List uint8) async {
          return uint8;
        }

        Stream<Uint8List> stream =
            Stream<Uint8List>.fromFuture(futureUint8(uint8ListImage!));

        request.files.add(
          http.MultipartFile(
            'image',
            stream,
            uint8ListImage!.lengthInBytes,
            filename: "filename",
            contentType: MediaType('image', 'png'),
          ),
        );

        dev.log("[DEBUG] >>> Set File :" + request.files.toString());

        dev.log("[DEBUG] >>> Set Request File :" + request.files.toString());

        // dev.log(request.files.toString());
        dev.log(request.fields.toString());

        request.fields['randomIdx'] = i.toString();
        request.headers.addAll(headers);

        dev.log("[DEBUG] >>> Request Data: " + request.toString());
        var response = await request.send();
        dev.log("[DEBUG] >>> Response Code: " + response.statusCode.toString());
        var resBytes = await response.stream.toBytes();

        dev.log("[DEBUG] >>> Response: Get Stream.");

        generatedNoDesByte![i] = resBytes.buffer.asUint8List();
        dev.log("[DEBUG] >>> Convery Stream to Uint8List");
        generatedNoDesImage![i] = Image.memory(resBytes.buffer.asUint8List());
        dev.log("[DEBUG] >>> Save Image into List.");
        setState(() {});
        await Future.delayed(Duration(seconds: 1));
      }
    } catch (e) {
      dev.log(" >>> Exception Uploading");
      dev.log(e.toString());
    }
  }

  void setChosen() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    setState(() {
      gender = sharedPrefs.getString(desType[0])!;
      _choosenSkin = sharedPrefs.getString("Skin Color")!;
      _choosenShape = sharedPrefs.getString("Face Shape")!;
      _choosenEyes = sharedPrefs.getString("Eyes")!;
      _choosenNose = sharedPrefs.getString("Nose")!;
      _choosenMouth = sharedPrefs.getString("Mouth")!;
      _choosenEars = sharedPrefs.getString("Ears")!;
      _choosenHair = sharedPrefs.getString("Hair")!;
      _choosenEyebrows = sharedPrefs.getString("Eyebrows")!;
      _choosenBeard = sharedPrefs.getString("Beard")!;
    });
  }

  /*
  *
  *
  *
  *     Build
  *
  *
  *
   */

  double canvasSize = 0;

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context);
    MediaQuery.of(context).padding.top - kToolbarHeight;
    dev.log(w.toString() + " " + h.toString());

    w = 1280;
    h = 768;

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
    canvasSize = size.getHalfWidth() - pad;

    return Scaffold(
      // bottomNavigationBar: buildBottomAppBar(w, context),
      body: Padding(
        padding: EdgeInsets.all(size.getPad()),
        child: Container(
          child: Scrollbar(
            controller: controllerOne,
            child: ListView(
              children: [
                Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text("*This application is built for Web on PC only*"),
                          InkWell(
                            child: Text("Download for Android Here", style: TextStyle(color: Colors.blue),),
                            onTap: ()=> launch("https://drive.google.com/file/d/1dw0tfKC6d1SjSME-FNrj9n656veI7lXt/view?usp=sharing"),
                          )
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildBorderContainer(
                            Container(
                              width: size.getHalfWidth(),
                              height: size.getHeight(),
                              child: Column(
                                children: [
                                  buildSumCanvas(),
                                  buildSumDescription(),
                                ],
                              ),
                            ),
                            size.getPad(),
                          ),
                          buildBorderContainer(
                            Container(
                              width: size.getHalfWidth(),
                              height: size.getHeight(),
                              child: Column(
                                children: [
                                  buildResult(),
                                  // buildSelectOutput(),
                                  buildButtons(context)
                                ],
                              ),
                            ),
                            size.getPad(),
                          ),
                          buildBorderContainer(
                            Container(
                              width: size.getHalfWidth(),
                              height: size.getHeight(),
                              child: Column(
                                children: [
                                  buildResultNoDes(),
                                ],
                              ),
                            ),
                            size.getPad(),
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

  /*
  *
  *
  *
  *     Widget
  *
  *
  *
   */

  // Padding buildSelectOutput() {
  //   return ;
  // }

  RaisedButton buildSelectImageBtn(int idx, String index) {
    String strIdx = (idx + 1).toString();
    return RaisedButton(
      textColor: Colors.black,
      color: Colors.grey,
      child: Text(strIdx, style: TextStyle(fontSize: size.getTextFont())),
      onPressed: () {
        if (index == 'no_des') {
          selectedNoDesIntex = idx;
        } else {
          selectedIntex = idx;
        }
        setState(() {});
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  Column buildSumCanvas() {
    print(" >>> Build Sum Canvas");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: size.getPad(), bottom: size.getPad()),
          child: Text("Sketch and Description",
              style: TextStyle(
                  fontSize: size.getTitleFont(), fontWeight: FontWeight.bold)),
        ),
        Container(
          child: uint8ListImage != null
              ? Container(
                  width: canvasSize,
                  height: canvasSize,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.memory(uint8ListImage!).image,
                      ),
                      border: Border.all(width: 1)),
                )
              : Container(
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  width: canvasSize,
                  height: canvasSize,
                  //child:  _show(picture, context),
                ),
        ),
      ],
    );
  }

  Expanded buildSumDescription() {
    return Expanded(
      child: Container(
        width: this.canvasSize,
        // height: h * 0.3,
        child: Padding(
            padding: EdgeInsets.all(size.getPad()),
            child: Scrollbar(
              controller: controllerTwo,
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
                  style: TextStyle(fontSize: size.getTextFont()),
                ),
              ),
            )),
      ),
    );
  }

  /*
  *
  *
  *
  *     Result
  *
  *
  *
   */

  void setChoosed() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      gender = sharedPrefs.getString(desType[0])!;
      _choosenSkin = sharedPrefs.getString("Skin Color")!;
      _choosenShape = sharedPrefs.getString("Face Shape")!;
      _choosenEyes = sharedPrefs.getString("Eyes")!;
      _choosenNose = sharedPrefs.getString("Nose")!;
      _choosenMouth = sharedPrefs.getString("Mouth")!;
      _choosenEars = sharedPrefs.getString("Ears")!;
      _choosenHair = sharedPrefs.getString("Hair")!;
      _choosenEyebrows = sharedPrefs.getString("Eyebrows")!;
      _choosenBeard = sharedPrefs.getString("Beard")!;
    });
  }

  Column buildResult() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: size.getPad(), bottom: size.getPad()),
          child: Text("Generated Face",
              style: TextStyle(
                  fontSize: size.getTitleFont(), fontWeight: FontWeight.bold)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width:1),
              ),
              child: generatedImage![selectedIntex] != null
                  ? Screenshot(
                controller: firstController,
                    child: Container(
                        width: this.canvasSize,
                        height: this.canvasSize,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: generatedImage![selectedIntex].image,
                            ),
                            ),
                      ),
                  )
                  : Container(
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      width: this.canvasSize,
                      height: this.canvasSize,
                    ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: size.getPad(), bottom: size.getPad()),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildSelectImageBtn(0, ""),
                buildSelectImageBtn(1, ""),
                buildSelectImageBtn(2, ""),
              ],
            ),
          ),
        )
      ],
    );
  }

  Uint8List? firstCaptured;
  Uint8List? secondCaptured;

  Future<Uint8List?> capture(ScreenshotController screenController) async{
    return await screenController.capture();
  }


  Column buildResultNoDes() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: size.getPad(), bottom: size.getPad()),
          child: Text("Generated Face (Sketch Only)",
              style: TextStyle(
                  fontSize: size.getTitleFont(), fontWeight: FontWeight.bold)),
        ),
        Row(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Screenshot(
              controller: secondController,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width:1),
                ),
                child: generatedNoDesImage![selectedNoDesIntex] != null
                    ? Container(
                        width: this.canvasSize,
                        height: this.canvasSize,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image:
                                  generatedNoDesImage![selectedNoDesIntex].image,
                            ),
                            ),
                      )
                    : Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        width: this.canvasSize,
                        height: this.canvasSize,
                      ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: size.getPad(), bottom: size.getPad()),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildSelectImageBtn(0, "no_des"),
                buildSelectImageBtn(1, "no_des"),
                buildSelectImageBtn(2, "no_des"),
              ],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.save_alt_outlined),
          splashColor: Colors.black,
          onPressed: () async {

            dev.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CheckCapture 1 : "+secondCaptured.toString());

            secondCaptured = await capture(secondController!);
            dev.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ChecssskCapture 2 : "+secondCaptured.toString());
            await _webImageDownloader.downloadImageFromUInt8List(
                uInt8List: secondCaptured!,imageQuality: 100);
            dev.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CheckCapture 3 : "+secondCaptured.toString());
          },
        ),

      ],
    );
  }

  Padding buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: size.getPad(), bottom: size.getPad()),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
              icon: const Icon(Icons.save_alt_outlined),
              splashColor: Colors.black,
              onPressed: () async {
                Uint8List? captured = await firstController.capture();
                Uint8List firstCaptured = captured!;
                await _webImageDownloader.downloadImageFromUInt8List(
                    uInt8List: firstCaptured,imageQuality: 100);
              },
            ),
            SizedBox(
              // width: pad*5,
              // height: size.getPad()*2,
              child: RaisedButton(
                  textColor: Colors.black,
                  color: Colors.blue,
                  child: Text(
                    "Edit Sketch or Description",
                    style: TextStyle(fontSize: size.getTitleFont() * 0.8),
                  ),
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
            IconButton(
                onPressed: () => showDialog(
                      barrierColor: Colors.black26,
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          width: size.getHalfWidth() / 2,
                          height: size.getHalfWidth() / 2,
                          child: CustomAlertDialog(
                              title: "Warning!",
                              description: "The created image will disappear\n" +
                                  "Make sure to save the image before return."),
                        );
                      },
                    ),
                icon: Icon(Icons.home_sharp))
          ]),
        ],
      ),
    );
  }
}

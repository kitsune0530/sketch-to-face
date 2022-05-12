import 'package:facegen/page/main_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../main.dart';
import '../web/main_web.dart';
import 'sizehelper.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class CustomAlertDialog extends StatefulWidget {
  CustomAlertDialog({Key? key, required this.title, required this.description})
      : super(key: key);
  String title = "", description = "";

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  // ContextSize size = new ContextSize();
  double? width, height, titleFont, textFont;

  _CustomAlertDialogState() {
    width = size.getWidth();
    // print(size.getHalfWidth());
    height = size.getHeight();
    // print(size.getHalfWidth());
    titleFont = size.getTitleFont();
    textFont = size.getTextFont();
  }

  @override
  Widget build(BuildContext context) {
    double h = displayHeight(context);

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: size.getHalfWidth(),
        height: size.getHeight() / 2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                // height: this.height*0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "${widget.title}",
                        style: TextStyle(
                          fontSize: titleFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "${widget.description}",
                      style: TextStyle(
                        fontSize: textFont,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Divider(
              //   height: 1,
              // ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   // height: width! * 0.1,
              //   child: InkWell(
              //     highlightColor: Colors.grey[200],
              //     onTap: () {
              //
              //       if(kIsWeb){
              //         // Navigator.push(
              //         //   context,
              //         //   MaterialPageRoute(builder: (context) => MainWebsite()),
              //         // );
              //       }else{
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(builder: (context) => MainMenu()),
              //         );
              //       }
              //     },
              //     child: Center(
              //       child: Text(
              //         "Start Over",
              //         style: TextStyle(
              //           fontSize: textFont,
              //           color: Theme.of(context).primaryColor,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Divider(
              //   height: 1,
              // ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   // height: width! * 0.1,
              //   child: TextButton(
              //     onPressed: () {
              //       Navigator.pop(context, 'Cancel');
              //     },
              //     child: Text("Cancel"),
              //   )
              // ),

              const Divider(
                height: 1,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  // height: width! * 0.1,
                  child: TextButton(
                    onPressed: () {
                      if (kIsWeb) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainWebsite()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainMenu()),
                        );
                      }
                    },
                    child: Text(
                      "Start Over",
                      style: TextStyle(fontSize: size.getTextFont()),
                    ),
                  )),
              const Divider(
                height: 1,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  // height: width! * 0.1,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: size.getTextFont(), color: Colors.red),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

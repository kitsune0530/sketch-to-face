import 'package:facegen/page/main_mobile.dart';
import 'package:facegen/web/main_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'sizehelper.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
class CustomAlertDialog extends StatefulWidget {
  CustomAlertDialog(
      {Key key,
      this.title,
      this.description,
      this.width,
      this.height,
      this.titleFont,
      this.textFont})
      : super(key: key);

  final String title, description;
  double width, height, titleFont, textFont;

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
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
        width: widget.width,
        height: widget.height,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: widget.height*0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "${widget.title}",
                        style: TextStyle(
                          fontSize: widget.titleFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "${widget.description}",
                      style: TextStyle(
                        fontSize: widget.textFont,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Divider(
                height: 1,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: widget.width * 0.1,
                child: InkWell(
                  highlightColor: Colors.grey[200],
                  onTap: () {

                    if(kIsWeb){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainWebsite()),
                      );
                    }else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainMenu()),
                      );
                    }
                  },
                  child: Center(
                    child: Text(
                      "Start Over",
                      style: TextStyle(
                        fontSize: widget.textFont,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 1,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: widget.width * 0.1,
                child: InkWell(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                  highlightColor: Colors.grey[200],
                  onTap: () {
                    Navigator.pop(context, "Cancel");
                  },
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: widget.textFont,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:facegen/page/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'sizehelper.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({
    Key key,
    this.title,
    this.description,
  }) : super(key: key);

  final String title, description;

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: h*0.15),
          Text(
            "${widget.title}",
            style: TextStyle(
              fontSize: h*0.018,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: h*0.015),
          Text("${widget.description}"),
          SizedBox(height: h*0.2),
          Divider(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: h*0.05,
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Lobby()),
                );
              },
              child: Center(
                child: Text(
                  "Back to main page",
                  style: TextStyle(
                    fontSize: h*0.018,
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
            height: h*0.05,
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
                    fontSize: h*0.018,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
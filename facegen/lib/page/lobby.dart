// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:facegen/page/canvas.dart';
import 'package:flutter/material.dart';
import 'package:facegen/helper/sizehelper.dart';
import 'package:flutter/services.dart';

class Lobby extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context);
    MediaQuery.of(context).padding.top - kToolbarHeight;
    return Scaffold(
        backgroundColor: Colors.white24,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: w*0.7, // match_parent
                child: Container(
                      child: Text('Face Generator', style: TextStyle(fontSize: w * 0.1, color: Colors.white)),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: w*0.1,
                        width: w*0.75,  // match_parent
                        child: RaisedButton(
                            textColor: Colors.black,
                            color: Colors.grey,
                            child: Text("Create Face", style: TextStyle(fontSize: w*0.06),),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Canvas()),
                              );
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: w*0.1,
                        width: w*0.75,  // match_parent
                        child: RaisedButton(
                          textColor: Colors.black,
                          color: Colors.grey,
                          child: Text("Generator Image",style: TextStyle(fontSize: w*0.06)),
                          onPressed: () {},
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: w*0.1,
                        width: w*0.75, // match_parent
                        child: RaisedButton(
                          textColor: Colors.black,
                          color: Colors.grey,
                          child: Text("Exit",style: TextStyle(fontSize: w*0.06)),
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                  ),
                    )


              ],
            ),
          )
        ],
      ),
    ));
  }
}

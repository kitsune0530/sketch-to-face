// ignore: file_names
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;
import 'main.dart';

class SharedPrefsHelper{


  static Future<String> getValue(String name)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(name) ?? '';
  }

  static void saveValue(String name, String value)async{
    final SharedPreferences? prefs = await SharedPreferences.getInstance();
    prefs?.setString(name, value) ?? '';
  }

  static void resetValues() async{
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString("Gender", null);
    // prefs.setString("Skin Color", null);
    // prefs.setString("Face Shape" ,null);
    // prefs.setString("Eyes", null);
    // prefs.setString("Nose", null);
    // prefs.setString("Mouth", null);
    // prefs.setString("Ears", null);
    // prefs.setString("Hair", null);
    // prefs.setString("Eyebrows",null);
    // prefs.setString("Beard", null);

    prefs.setString("Gender", defaultDes[0]);
    prefs.setString("Skin Color", defaultDes[1]);
    prefs.setString("Face Shape" ,defaultDes[2]);
    prefs.setString("Eyes", defaultDes[3]);
    prefs.setString("Nose", defaultDes[4]);
    prefs.setString("Mouth", defaultDes[5]);
    prefs.setString("Ears", defaultDes[6]);
    prefs.setString("Hair", defaultDes[7]);
    prefs.setString("Eyebrows",defaultDes[8]);
    prefs.setString("Beard", defaultDes[9]);
  }


  // static Future<List<int>> getDescriptionList() async {
  //   List<List<String>> sumsDes = [
  //     genderList,
  //     skinList,
  //     shapeList,
  //     eyesList,
  //     noseList,
  //     mouthList,
  //     earsList,
  //     hairList,
  //     eyebrowsList,
  //     beardList
  //   ];
  //   int sumsLength = sumsDes.length;
  //   // dev.log("sumsLength  = " + sumsLength.toString());
  //   dev.log(" >>> Start Loop");
  //   int i = 0;
  //   List<int> intList=[];
  //   for (i; i < sumsLength; i = i + 1) {
  //     String temp = await SharedPrefsHelper.getValue(desType[i]);
  //     // dev.log(temp+"[Length "+temp.length.toString()+"]");
  //     dev.log("List " + i.toString() + " : " + sumsDes[i].toString());
  //     int idx = sumsDes[i].indexWhere((element) => element == temp);
  //     descriptionList[i] = idx;
  //     dev.log("Index " +
  //         i.toString() +
  //         " : " +
  //         descriptionList[i].toString() +
  //         "(${temp})");
  //   }
  //   dev.log(" >>> End Loop ${i.toString()}");
  //   dev.log("Index " " : " + descriptionList.toString());
  //
  //   return descriptionList;
  // }
}
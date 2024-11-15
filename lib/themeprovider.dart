import 'package:flutter/material.dart';
import 'package:habittracker/darkmode.dart';
import 'package:habittracker/lightmode.dart';

class Themeprovider extends ChangeNotifier{
  //initially light mode
  ThemeData _themeData=lightmode;


  //get current theme
  ThemeData get themeData=> _themeData;

  //is current theme dark mode
  bool get isdarkMode=>_themeData==darkmode;

  //set theme
  set themeData(ThemeData themeData){
    _themeData=themeData;
    notifyListeners();
  }

    //toggle theme
    void toggleTheme(){
      if(_themeData==lightmode){
        themeData=darkmode;
      }else{
        themeData=lightmode;
      }
    }
}
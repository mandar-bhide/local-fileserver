import 'package:flutter/material.dart';

class CustomColors{
  static Color primaryColor = Color(0xFF2D5ED2);
  static Color primaryDark = Color(0xFF06113C);
  static Color lightLight = Color(0xFF6191E5);
  static Color darkLight = Color.fromRGBO(200, 230, 255, 1);
  
  static Color darkBg = Color.fromRGBO(45, 68, 96, 1);
  static Color lightBg = Colors.white;

  static Color darkTextColor = Colors.white;
  static Color lightTextColor = Colors.black;

  static Color getBgColor()=>CustomColors.lightBg;
  static Color getTextColor()=>CustomColors.lightTextColor;
  static Color getLightColor()=>CustomColors.lightLight;
}
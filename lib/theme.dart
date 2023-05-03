import 'package:flutter/material.dart';

class Themes {
  static const Color backgroundColor = Color(0xfff9f9f9);
  static const Color lighbackgroundColor = Color(0xffffffff);
  static const Color textcolor = Color(0xff4b4b4b);
  static const Color lightblue = Color(0xff01b0ef);
  static const Color darkblue = Color(0xff0041a8);
  static const Color yeloo = Color(0xff0041a8);
  static const Color lightgrey = Color(0xff9a9a9a);
  static const Color grey = Color(0xff8c8c8c);
  static const Color red = Color(0xffff6f3c);

  static ThemeData lightTheme = ThemeData(
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
      ),
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: lightblue,
      textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontFamily: 'gotham',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: textcolor),
          titleMedium: TextStyle(
              fontFamily: 'gotham',
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: textcolor),
          headlineLarge: TextStyle(
              fontFamily: 'gotham',
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: textcolor),
          bodyMedium: TextStyle(
            fontFamily: 'gotham',
            fontSize: 20,
            color: textcolor,
          ),
          bodySmall: TextStyle(
              fontFamily: 'gotham',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: textcolor)),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 30,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ));
}

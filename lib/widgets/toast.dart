import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital/theme.dart';

class ToastMessage {
  static toastmessage(String message, bool type) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: type == true ? Themes.red : Themes.textcolor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

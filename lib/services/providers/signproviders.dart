import 'package:flutter/material.dart';

class signprividers with ChangeNotifier {
  bool loading = false;
  bool islogin = true;
  bool smscurser = true;
  bool isadoctor = false;
  String specialty = '';

  changeloading(bool value) {
    loading = value;
    notifyListeners();
  }

  changspeciality(String value) {
    specialty = value;
    notifyListeners();
  }

  changeisadoctor(bool value) {
    isadoctor = value;
    notifyListeners();
  }

  changesmscurser(bool value) {
    smscurser = value;
    notifyListeners();
  }

  changeislogin(bool value) {
    islogin = value;
    notifyListeners();
  }
}

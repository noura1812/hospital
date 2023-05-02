import 'package:flutter/material.dart';

class signprividers with ChangeNotifier {
  bool loading = false;
  bool islogin = true;
  bool smscurser = true;
  changeloading(bool value) {
    loading = value;
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

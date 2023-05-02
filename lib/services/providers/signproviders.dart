import 'package:flutter/material.dart';

class signprividers with ChangeNotifier {
  bool loading = false;
  bool islogin = true;
  changeloading(bool value) {
    loading = value;
    notifyListeners();
  }

  changeislogin(bool value) {
    islogin = value;
    notifyListeners();
  }
}

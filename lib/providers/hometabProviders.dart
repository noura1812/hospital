// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:hospital/model/fieldsmodel.dart';
import 'package:hospital/services/firebase/firebase_main_functions.dart';

class HmeTabProviders with ChangeNotifier {
  var userdata;

  User? firebaseUser;

  List<FieldsModel> fields = [
    FieldsModel(
      name: 'Ophthalmology',
      selected: false,
      icon: Icons.remove_red_eye,
    ),
    FieldsModel(
        name: 'Otolaryngology',
        selected: false,
        icon: ('assets/images/nose_icon.png')),
    FieldsModel(
      selected: false,
      name: 'Cardiology',
      icon: Icons.favorite,
    ),
    FieldsModel(
        selected: false,
        name: 'Dermatology',
        icon: 'assets/images/dermatologist.png'),
    FieldsModel(
        selected: false,
        name: 'Dentist',
        icon: ('assets/images/tooth icon.png')),
  ];
  String speciality = '';
  HmeTabProviders() {
    firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      chekUser();
    }
  }
  void chekUser() async {
    var doctor = await FirebaseMainFunctions.getDoctorsById(firebaseUser!.uid);
    var pationt =
        await FirebaseMainFunctions.getPationtsById(firebaseUser!.uid);
    if (doctor.exists) {
      userdata = doctor.data()!;
      notifyListeners();
    } else if (pationt.exists) {
      userdata = pationt.data()!;
      notifyListeners();
    }
  }

  changeSpeciality(String value) {
    speciality = value;
    notifyListeners();
  }

  setUserData(value) {
    userdata = value;
    notifyListeners();
  }

  resetFields() {
    fields = [
      FieldsModel(
        name: 'Ophthalmology',
        selected: false,
        icon: Icons.remove_red_eye,
      ),
      FieldsModel(
          name: 'Otolaryngology',
          selected: false,
          icon: ('assets/images/nose_icon.png')),
      FieldsModel(
        selected: false,
        name: 'Cardiology',
        icon: Icons.favorite,
      ),
      FieldsModel(
          selected: false,
          name: 'Dermatology',
          icon: 'assets/images/dermatologist.png'),
      FieldsModel(
          selected: false,
          name: 'Dentist',
          icon: ('assets/images/tooth icon.png')),
    ];
    notifyListeners();
  }

  selectField(FieldsModel e) {
    fields
        .where((num1) => num1.name != e.name)
        .forEach((num2) => fields[fields.indexOf(num2)].selected = false);
    fields.where((element) => element.name == e.name).first.selected = true;
    e.selected = true;

    notifyListeners();
  }
}

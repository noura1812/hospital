import 'package:flutter/material.dart';
import 'package:hospital/model/fieldsmodel.dart';

class HmeTabProviders with ChangeNotifier {
  var userdata;
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

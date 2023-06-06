// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital/model/appointment.dart';

import 'package:hospital/model/fields_model.dart';
import 'package:hospital/services/firebase/firebase_main_functions.dart';

class HomeTabProviders with ChangeNotifier {
  var userData;
  bool isDoctor = false;
  User? firebaseUser;
  Appointment? editAppointment;
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
  String specialty = '';
  HomeTabProviders() {
    firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      chickUser();
    }
  }
  void chickUser() async {
    var doctor = await FirebaseMainFunctions.getDoctorsById(firebaseUser!.uid);
    var pationt =
        await FirebaseMainFunctions.getPatientsById(firebaseUser!.uid);
    if (doctor.exists) {
      userData = doctor.data()!;
      isDoctor = true;
      notifyListeners();
    } else if (pationt.exists) {
      userData = pationt.data()!;
      isDoctor = false;
      notifyListeners();
    }
  }

  setEditAppointment(Appointment? value) {
    editAppointment = value;
    notifyListeners();
  }

  addUserAppointment(Appointment appointment) {
    userData.appointments.add(appointment);
    notifyListeners();
  }

  deleteUserAppointment(String id) {
    userData.appointments.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  changeSpecialty(String value) {
    specialty = value;
    notifyListeners();
  }

  setUserData(value) {
    userData = value;
    notifyListeners();
  }

  setIsDoctor(bool value) {
    isDoctor = value;
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

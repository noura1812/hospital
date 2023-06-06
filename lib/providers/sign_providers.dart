import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/model/patient_model.dart';
import 'package:hospital/model/working_hours.dart';

class SignProvider with ChangeNotifier {
  bool loading = false;
  bool isLogin = true;
  bool verified = false;
  bool isaDoctor = false;
  bool verifying = false;

  String verificationId = '';
  File? imageFile;
  PatientModel patientData =
      PatientModel(name: '', phoneNumber: '', imageUrl: '', appointments: []);

  String specialty = 'Ophthalmologist';
  List<int> days = [];
  String about = '';
  String yearsOfExp = '';

  String startPm = 'PM';
  String endPm = 'PM';
  String startTime = '';
  String endTime = '';

  String name = '';
  String imageUrl = '';
  String phone = '';

  void pickedImage(File pickedImage) {
    imageFile = pickedImage;
    notifyListeners();
  }

  changeVerificationId(String value) {
    verificationId = value;
    notifyListeners();
  }

  DoctorsModel doctorsData = DoctorsModel(
      name: '',
      phoneNumber: '',
      specialty: '',
      about: '',
      yearsOfExp: '',
      imageUrl: '',
      reviews: [],
      workingHours: WorkingHoursModel(startHour: '', endHour: '', days: []),
      appointments: []);

  changeLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  changVerifying(bool value) {
    verifying = value;
    notifyListeners();
  }

  setDoctorsData() {
    doctorsData = DoctorsModel(
        reviews: [],
        name: name,
        phoneNumber: phone,
        specialty: specialty,
        about: about,
        yearsOfExp: yearsOfExp,
        imageUrl: imageUrl,
        workingHours: WorkingHoursModel(
            startHour: '$startTime $startPm',
            endHour: '$endTime $endPm',
            days: days),
        appointments: []);
    notifyListeners();
  }

  setPatientsData() {
    patientData = PatientModel(
        name: name, phoneNumber: phone, imageUrl: imageUrl, appointments: []);
    notifyListeners();
  }

  getDoctorsData(DoctorsModel doctorsModel) {
    doctorsData = DoctorsModel(
        reviews: [],
        id: doctorsModel.id,
        name: doctorsModel.name,
        phoneNumber: doctorsModel.phoneNumber,
        specialty: doctorsModel.specialty,
        about: doctorsModel.about,
        yearsOfExp: doctorsModel.yearsOfExp,
        imageUrl: doctorsModel.imageUrl,
        workingHours: WorkingHoursModel(
            startHour: doctorsModel.workingHours.startHour,
            endHour: doctorsModel.workingHours.endHour,
            days: doctorsModel.workingHours.days),
        appointments: []);
    notifyListeners();
  }

  setDoctorsUrl(String url) {
    doctorsData.imageUrl = url;
    notifyListeners();
  }

  setPatientsUrl(String url) {
    imageUrl = url;
    notifyListeners();
  }

  getPatientsData(PatientModel patientModel) {
    patientData = PatientModel(
        name: patientModel.name,
        id: patientData.id,
        phoneNumber: patientModel.phoneNumber,
        imageUrl: patientModel.imageUrl,
        appointments: []);
  }

  setDayValue(value) {
    days = value;
    notifyListeners();
  }

  changSpecialty(String value) {
    specialty = value;
    notifyListeners();
  }

  changPhone(String value) {
    phone = '0$value';
    notifyListeners();
  }

  changName(String value) {
    name = value;
    notifyListeners();
  }

  changImageUrl(String value) {
    imageUrl = value;
    notifyListeners();
  }

  changAbout(String value) {
    about = value;
    notifyListeners();
  }

  changYearsOfExp(String value) {
    yearsOfExp = value;
    notifyListeners();
  }

  changeStartPm(String value) {
    startPm = value;
    notifyListeners();
  }

  changeEndPm(String value) {
    endPm = value;
    notifyListeners();
  }

  changStartTime(String value) {
    startTime = value;
    notifyListeners();
  }

  changEndTime(String value) {
    endTime = value;
    notifyListeners();
  }

  changeIsaDoctor(bool value) {
    isaDoctor = value;
    notifyListeners();
  }

  changeVerified(bool value) {
    verified = value;
    notifyListeners();
  }

  changeIsLogin(bool value) {
    isLogin = value;
    notifyListeners();
  }
}

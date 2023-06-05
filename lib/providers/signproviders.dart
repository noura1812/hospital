import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/model/pationtmodel.dart';
import 'package:hospital/model/workinghours.dart';

class Signprividers with ChangeNotifier {
  bool loading = false;
  bool islogin = true;
  bool verified = false;
  bool isadoctor = false;
  bool verefing = false;

  int countDown = 70;
  String verificationId = '';
  File? imageFile;
  PationtModel pationtdata =
      PationtModel(name: '', phoneNumber: '', imageurl: '', appointments: []);

  String specialty = 'Ophthalmologist';
  List<int> days = [];
  String about = '';
  String yersofexp = '';

  String startpm = 'PM';
  String endpm = 'PM';
  String starttime = '';
  String endtime = '';

  String name = '';
  String imageurl = '';
  String phone = '';

  void pickedImage(File pickedImage) {
    imageFile = pickedImage;
    notifyListeners();
  }

  changeVerificationId(String value) {
    verificationId = value;
    notifyListeners();
  }

  changeCounDown() {
    countDown = countDown - 1;
    notifyListeners();
  }

  resetCounDown() {
    countDown = 70;
    notifyListeners();
  }

  DoctorsModel doctorsdata = DoctorsModel(
      name: '',
      phoneNumber: '',
      specialty: '',
      about: '',
      yersofexp: '',
      imageurl: '',
      reviews: [],
      workinghours: WorkingHoursModel(starthour: '', endhour: '', days: []),
      appointments: []);

  changeloading(bool value) {
    loading = value;
    notifyListeners();
  }

  changverifing(bool value) {
    verefing = value;
    notifyListeners();
  }

  setdoctorsdata() {
    doctorsdata = DoctorsModel(
        reviews: [],
        name: name,
        phoneNumber: phone,
        specialty: specialty,
        about: about,
        yersofexp: yersofexp,
        imageurl: imageurl,
        workinghours: WorkingHoursModel(
            starthour: '$starttime $startpm',
            endhour: '$endtime $endpm',
            days: days),
        appointments: []);
    notifyListeners();
  }

  setpatentsdata() {
    pationtdata = PationtModel(
        name: name, phoneNumber: phone, imageurl: imageurl, appointments: []);
    notifyListeners();
  }

  getdoctorsdata(DoctorsModel doctorsModel) {
    doctorsdata = DoctorsModel(
        reviews: [],
        id: doctorsModel.id,
        name: doctorsModel.name,
        phoneNumber: doctorsModel.phoneNumber,
        specialty: doctorsModel.specialty,
        about: doctorsModel.about,
        yersofexp: doctorsModel.yersofexp,
        imageurl: doctorsModel.imageurl,
        workinghours: WorkingHoursModel(
            starthour: doctorsModel.workinghours.starthour,
            endhour: doctorsModel.workinghours.endhour,
            days: doctorsModel.workinghours.days),
        appointments: []);
    notifyListeners();
  }

  setDoctorsUrl(String url) {
    doctorsdata.imageurl = url;
    notifyListeners();
  }

  setPAtiontssUrl(String url) {
    imageurl = url;
    notifyListeners();
  }

  getPationtsData(PationtModel pationtModel) {
    pationtdata = PationtModel(
        name: pationtModel.name,
        id: pationtdata.id,
        phoneNumber: pationtModel.phoneNumber,
        imageurl: pationtModel.imageurl,
        appointments: []);
  }

  setdayvalue(value) {
    days = value;
    notifyListeners();
  }

  changspeciality(String value) {
    specialty = value;
    notifyListeners();
  }

  changphone(String value) {
    phone = '0$value';
    notifyListeners();
  }

  changname(String value) {
    name = value;
    notifyListeners();
  }

  changimageurl(String value) {
    imageurl = value;
    notifyListeners();
  }

  changabout(String value) {
    about = value;
    notifyListeners();
  }

  changyearsofexp(String value) {
    yersofexp = value;
    notifyListeners();
  }

  changstartpm(String value) {
    startpm = value;
    notifyListeners();
  }

  changendtpm(String value) {
    endpm = value;
    notifyListeners();
  }

  changstarttime(String value) {
    starttime = value;
    notifyListeners();
  }

  changendtine(String value) {
    endtime = value;
    notifyListeners();
  }

  changeisadoctor(bool value) {
    isadoctor = value;
    notifyListeners();
  }

  changeverified(bool value) {
    verified = value;
    notifyListeners();
  }

  changeislogin(bool value) {
    islogin = value;
    notifyListeners();
  }
}

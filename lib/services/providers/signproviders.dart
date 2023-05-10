import 'package:flutter/material.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/model/pationtmodel.dart';
import 'package:hospital/model/workinghours.dart';

class signprividers with ChangeNotifier {
  bool loading = false;
  bool islogin = true;
  bool smscurser = true;
  bool isadoctor = false;

  PationtModel pationtdata =
      PationtModel(name: '', phone: '', imageurl: '', password: '');

  DoctorsModel doctorsdata = DoctorsModel(
      password: '',
      name: '',
      phoneNumber: '',
      specialty: '',
      about: '',
      yersofexp: '',
      imageurl: '',
      workinghours: WorkingHoursModel(starthour: '', endhour: '', days: []));

  String specialty = 'Ophthalmologist';
  List days = [];
  String about = '';
  String yersofexp = '';

  String startpm = 'PM';
  String endpm = 'PM';
  String starttime = '';
  String endtime = '';

  String name = '';
  String password = '';
  String imageurl = '';
  String phone = '';

  changeloading(bool value) {
    loading = value;
    notifyListeners();
  }

  setdoctorsdata() {
    doctorsdata = DoctorsModel(
        name: name,
        password: password,
        phoneNumber: phone,
        specialty: specialty,
        about: about,
        yersofexp: yersofexp,
        imageurl: imageurl,
        workinghours: WorkingHoursModel(
            starthour: '$starttime $startpm',
            endhour: '$endtime $endpm',
            days: days));
    notifyListeners();
  }

  getdoctorsdata(DoctorsModel doctorsModel) {
    doctorsdata = DoctorsModel(
        name: doctorsModel.name,
        password: doctorsModel.password,
        phoneNumber: doctorsModel.phoneNumber,
        specialty: doctorsModel.specialty,
        about: doctorsModel.about,
        yersofexp: doctorsModel.yersofexp,
        imageurl: doctorsModel.imageurl,
        workinghours: WorkingHoursModel(
            starthour: doctorsModel.workinghours.starthour,
            endhour: doctorsModel.workinghours.endhour,
            days: doctorsModel.workinghours.days));
    notifyListeners();
  }

  getPationtsData(PationtModel pationtModel) {
    pationtdata = PationtModel(
        name: pationtModel.name,
        phone: pationtModel.phone,
        imageurl: pationtModel.imageurl,
        password: pationtModel.password);
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
    phone = value;
    notifyListeners();
  }

  changname(String value) {
    name = value;
    notifyListeners();
  }

  changpassword(String value) {
    password = value;
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

  changesmscurser(bool value) {
    smscurser = value;
    notifyListeners();
  }

  changeislogin(bool value) {
    islogin = value;
    notifyListeners();
  }
}

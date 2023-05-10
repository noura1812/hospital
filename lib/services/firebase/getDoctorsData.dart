import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/model/workinghours.dart';

class GetDoctorsData with ChangeNotifier {
  List<DoctorsModel> doctors = [];
  getData() async {
    doctors = [];
    await FirebaseFirestore.instance.collection('doctors').get().then((value) {
      value.docs.forEach((data) {
        doctors.add(DoctorsModel(
            name: data['username'],
            phoneNumber: data['phone'],
            specialty: data['specialty'],
            about: data['about'],
            yersofexp: data['yersofexp'],
            imageurl: data['imageurl'],
            password: data['password'],
            workinghours: WorkingHoursModel(
                starthour: data['statworkinghours'],
                endhour: data['endworkinghours'],
                days: data['workingdays'])));
      });
    });
    notifyListeners();
  }
}

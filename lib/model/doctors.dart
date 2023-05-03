import 'package:hospital/model/reviewmodel.dart';
import 'package:hospital/model/workinghours.dart';

class DoctorsModel {
  String name;
  String phoneNumber;
  String specialty;
  String about;
  String yersofexp;
  String imageurl;
  String password;
  WorkingHoursModel workinghours;
  List<Reviewsmodel>? reviews;
  DoctorsModel({
    required this.name,
    required this.phoneNumber,
    required this.specialty,
    required this.about,
    required this.yersofexp,
    required this.imageurl,
    required this.password,
    required this.workinghours,
    this.reviews,
  });
}

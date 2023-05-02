import 'package:hospital/model/reviewmodel.dart';

class DoctorsModel {
  String name;
  String phoneNumber;
  String field;
  int yersofexp;
  String imageurl;
  List<Reviewsmodel>? reviews;
  DoctorsModel({
    required this.name,
    required this.phoneNumber,
    required this.field,
    required this.yersofexp,
    required this.imageurl,
    this.reviews,
  });
}

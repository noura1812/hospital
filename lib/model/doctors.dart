import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hospital/model/appointment.dart';
import 'package:hospital/model/reviewmodel.dart';
import 'package:hospital/model/workinghours.dart';

class DoctorsModel {
  String id;
  String name;
  String phoneNumber;
  String specialty;
  String about;
  String yersofexp;
  String imageurl;
  WorkingHoursModel workinghours;
  List<Reviewsmodel> reviews;
  List<Appointment> appointments;
  DoctorsModel({
    this.id = '',
    required this.name,
    required this.phoneNumber,
    required this.specialty,
    required this.about,
    required this.yersofexp,
    required this.imageurl,
    required this.workinghours,
    required this.reviews,
    required this.appointments,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'about': about,
      'imageurl': imageurl,
      'name': name,
      'phoneNumber': phoneNumber,
      'specialty': specialty,
      'yersofexp': yersofexp,
      'starthour': workinghours.starthour,
      'endhour': workinghours.endhour,
      'days': FieldValue.arrayUnion(workinghours.days),
      'reviews': List<dynamic>.from(reviews.map((review) => review.toJson())),
      'appointments': List<dynamic>.from(
          appointments.map((appointment) => appointment.toJson()))
    };
  }

  DoctorsModel.fromjson(Map<String, dynamic> json)
      : this(
          appointments: (json['appointments'] != null)
              ? List<Appointment>.from(json['appointments']
                  .map((review) => Appointment.fromJson(review)))
              : [],
          id: json['id'],
          about: json['about'],
          imageurl: json['imageurl'],
          name: json['name'],
          phoneNumber: json['phoneNumber'],
          specialty: json['specialty'],
          workinghours: WorkingHoursModel(
              starthour: json['starthour'],
              endhour: json['endhour'],
              days: (json['days'] != null) ? List<int>.from(json['days']) : []),
          yersofexp: json['yersofexp'],
          reviews: (json['reviews'] != null)
              ? List<Reviewsmodel>.from(json['reviews']
                  .map((review) => Reviewsmodel.fromjson(review)))
              : [],
        );
}

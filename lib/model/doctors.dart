import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hospital/model/appointment.dart';
import 'package:hospital/model/review_model.dart';
import 'package:hospital/model/working_hours.dart';

class DoctorsModel {
  String id;
  String name;
  String phoneNumber;
  String specialty;
  String about;
  String yearsOfExp;
  String imageUrl;
  WorkingHoursModel workingHours;
  List<ReviewsModel> reviews;
  List<Appointment> appointments;
  DoctorsModel({
    this.id = '',
    required this.name,
    required this.phoneNumber,
    required this.specialty,
    required this.about,
    required this.yearsOfExp,
    required this.imageUrl,
    required this.workingHours,
    required this.reviews,
    required this.appointments,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'about': about,
      'imageurl': imageUrl,
      'name': name,
      'phoneNumber': phoneNumber,
      'specialty': specialty,
      'yersofexp': yearsOfExp,
      'starthour': workingHours.startHour,
      'endhour': workingHours.endHour,
      'days': FieldValue.arrayUnion(workingHours.days),
      'reviews': List<dynamic>.from(reviews.map((review) => review.toJson())),
      'appointments': List<dynamic>.from(
          appointments.map((appointment) => appointment.toJson()))
    };
  }

  DoctorsModel.fromJson(Map<String, dynamic> json)
      : this(
          appointments: (json['appointments'] != null)
              ? List<Appointment>.from(json['appointments']
                  .map((review) => Appointment.fromJson(review)))
              : [],
          id: json['id'],
          about: json['about'],
          imageUrl: json['imageurl'],
          name: json['name'],
          phoneNumber: json['phoneNumber'],
          specialty: json['specialty'],
          workingHours: WorkingHoursModel(
              startHour: json['starthour'],
              endHour: json['endhour'],
              days: (json['days'] != null) ? List<int>.from(json['days']) : []),
          yearsOfExp: json['yersofexp'],
          reviews: (json['reviews'] != null)
              ? List<ReviewsModel>.from(json['reviews']
                  .map((review) => ReviewsModel.fromJson(review)))
              : [],
        );
}

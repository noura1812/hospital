// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hospital/model/appointment.dart';

class PatientModel {
  String name;
  String phoneNumber;
  String imageUrl;
  String id;
  List<Appointment> appointments;

  PatientModel({
    required this.name,
    this.id = '',
    required this.phoneNumber,
    required this.imageUrl,
    required this.appointments,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'imageurl': imageUrl,
      'appointments': List<dynamic>.from(
          appointments.map((appointment) => appointment.toJson()))
    };
  }

  PatientModel.fromJson(Map<String, dynamic> json)
      : this(
          appointments: (json['appointments'] != null)
              ? List<Appointment>.from(json['appointments']
                  .map((review) => Appointment.fromJson(review)))
              : [],
          id: json['id'],
          imageUrl: json['imageurl'],
          name: json['name'],
          phoneNumber: json['phoneNumber'],
        );
}

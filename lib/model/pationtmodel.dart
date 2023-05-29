// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hospital/model/appointment.dart';

class PationtModel {
  String name;
  String phoneNumber;
  String imageurl;
  String id;
  List<Appointment> appointments;

  PationtModel({
    required this.name,
    this.id = '',
    required this.phoneNumber,
    required this.imageurl,
    required this.appointments,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'imageurl': imageurl,
      'appointments': List<dynamic>.from(
          appointments.map((appointment) => appointment.toJson()))
    };
  }

  PationtModel.fromjson(Map<String, dynamic> json)
      : this(
          appointments: (json['appointments'] != null)
              ? List<Appointment>.from(json['appointments']
                  .map((review) => Appointment.fromJson(review)))
              : [],
          id: json['id'],
          imageurl: json['imageurl'],
          name: json['name'],
          phoneNumber: json['phoneNumber'],
        );
}

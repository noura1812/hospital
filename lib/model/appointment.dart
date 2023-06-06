class Appointment {
  String id;
  String patientsID;
  String doctorsID;
  int date;
  String complains;
  Appointment({
    required this.id,
    required this.patientsID,
    required this.doctorsID,
    required this.date,
    required this.complains,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pationtsID': patientsID,
      'doctorsID': doctorsID,
      'complains': complains,
      'date': date
    };
  }

  Appointment.fromJson(Map<String, dynamic> json)
      : this(
            date: json['date'],
            doctorsID: json['doctorsID'],
            id: json['id'],
            patientsID: json['pationtsID'],
            complains: json['complains']);
}

class Appointment {
  String id;
  String pationtsID;
  String doctorsID;
  int date;
  String complains;
  Appointment({
    required this.id,
    required this.pationtsID,
    required this.doctorsID,
    required this.date,
    required this.complains,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pationtsID': pationtsID,
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
            pationtsID: json['pationtsID'],
            complains: json['complains']);
}

class Appointment {
  String id;
  String pationtsID;
  String doctorsID;
  int date;
  String time;
  Appointment({
    required this.id,
    required this.pationtsID,
    required this.doctorsID,
    required this.date,
    required this.time,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pationtsID': pationtsID,
      'doctorsID': doctorsID,
      'time': time,
      'date': date
    };
  }

  Appointment.fromJson(Map<String, dynamic> json)
      : this(
            date: json['date'],
            doctorsID: json['doctorsID'],
            id: json['id'],
            pationtsID: json['pationtsID'],
            time: json['time']);
}

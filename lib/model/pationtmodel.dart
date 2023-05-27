// ignore_for_file: public_member_api_docs, sort_constructors_first
class PationtModel {
  String name;
  String phone;
  String imageurl;
  String id;

  PationtModel({
    required this.name,
    this.id = '',
    required this.phone,
    required this.imageurl,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'imageurl': imageurl,
    };
  }

  PationtModel.fromjson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          imageurl: json['imageurl'],
          name: json['name'],
          phone: json['phone'],
        );
}

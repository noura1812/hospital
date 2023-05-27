class Reviewsmodel {
  String id;
  String name;
  String review;
  int numstars;
  Reviewsmodel({
    required this.id,
    required this.name,
    required this.review,
    required this.numstars,
  });
  Reviewsmodel.fromjson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            name: json['name'],
            numstars: json['numstars'],
            review: json['review']);

  Map<String, dynamic> toJson() {
    return {'name': name, 'review': review, 'numstars': numstars, 'id': id};
  }
}

class ReviewsModel {
  String id;
  String name;
  String review;
  int numStars;
  ReviewsModel({
    required this.id,
    required this.name,
    required this.review,
    required this.numStars,
  });
  ReviewsModel.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            name: json['name'],
            numStars: json['numstars'],
            review: json['review']);

  Map<String, dynamic> toJson() {
    return {'name': name, 'review': review, 'numstars': numStars, 'id': id};
  }
}

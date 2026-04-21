class ReviewModel {
  final int id;
  final String name;
  final double rating;

  final String? review;
  final String? picture;
  final DateTime createdAt;
  final DateTime updatedAt;
  ReviewModel({
    required this.id,
    required this.name,
    required this.rating,

    this.review,
    this.picture,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      name: json['username'],
      rating: json['rating'],

      review: json['review'],

      picture: json['userProfilePicture'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

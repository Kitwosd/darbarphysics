class BannerModel {
  final int courseId;
  final String title;
  final String image;
  const BannerModel({
    required this.courseId,
    required this.title,
    required this.image,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      courseId: json['id'],
      title: json['title'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': courseId, 'title': title, 'image': image};
  }
}

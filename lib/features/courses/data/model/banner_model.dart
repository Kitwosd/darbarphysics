import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    final baseThumbnailUrl = dotenv.env['BASE_THUMBNAIL_URL'];

    String imagePath = json['image'];

    if (imagePath.isNotEmpty && !imagePath.startsWith('http')) {
      imagePath = '$baseThumbnailUrl$imagePath';
    }
    return BannerModel(
      courseId: json['id'],
      title: json['title'],
      image: imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': courseId, 'title': title, 'image': image};
  }
}

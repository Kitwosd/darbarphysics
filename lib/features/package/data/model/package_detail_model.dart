import 'package:durbar_physics/features/package/data/model/package_course_model.dart';
import 'package:equatable/equatable.dart';

class PackageDetailModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String image;
  final String price;
  final bool isActive;
  final int courseCount;
  final List<PackageCourse> courses;
  final String createdAt;

  const PackageDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.isActive,
    required this.courseCount,
    required this.courses,
    required this.createdAt,
  });

  factory PackageDetailModel.fromJson(Map<String, dynamic> json) {
    return PackageDetailModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? '0.00',
      isActive: json['is_active'] ?? false,
      courseCount: json['course_count'] ?? 0,
      courses:
          (json['courses'] as List<dynamic>?)
              ?.map((course) => PackageCourse.fromJson(course))
              .toList() ??
          [],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'is_active': isActive,
      'course_count': courseCount,
      'courses': courses.map((course) => course.toJson()).toList(),
      'created_at': createdAt,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    image,
    price,
    isActive,
    courseCount,
    courses,
    createdAt,
  ];
}

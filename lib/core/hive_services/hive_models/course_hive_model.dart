// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'course_hive_model.g.dart';

@HiveType(typeId: 2)
class CourseHiveModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String cost;
  @HiveField(4)
  final String image;
  @HiveField(5)
  final double rating;
  @HiveField(6)
  final int studentCount;
  @HiveField(7)
  final int lessonCount;
  CourseHiveModel({
    this.id = 0,
    this.title = '',
    this.description = '',
    this.cost = '',
    this.image = '',
    this.studentCount = 0,
    this.lessonCount = 0,
    this.rating = 0,
  });
}

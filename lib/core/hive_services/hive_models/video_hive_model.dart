import 'package:hive_flutter/adapters.dart';
part 'video_hive_model.g.dart';

@HiveType(typeId: 1)
class VideoHiveModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final bool isLocked;
  @HiveField(3)
  final String? course;
  @HiveField(4)
  final String videoUrl;
  @HiveField(5)
  final String thumbnail;
  @HiveField(6)
  final String duration;

  VideoHiveModel({
    this.id = 0,
    this.title = '',
    this.isLocked = true,
    this.course = '',
    this.videoUrl = '',
    this.thumbnail = '',
    this.duration = '',
  });
}

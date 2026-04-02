import 'package:durbar_physics/core/hive_services/hive_models/video_hive_model.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';

extension VideoToHive on VideoModel {
  VideoHiveModel toHive() => VideoHiveModel(
    id: id,
    title: title,
    isLocked: isLocked,
    videoUrl: videoUrl,
    thumbnail: thumbnail,
    duration: duration,
    isUserLocked: isUserLocked,
    course: course,
    levelName: levelName,
    subjectName: subjectName,
  );
}

extension HiveToVideo on VideoHiveModel {
  VideoModel toVideo() => VideoModel(
    id: id,
    title: title,
    isLocked: isLocked,
    videoUrl: videoUrl,
    thumbnail: thumbnail,
    duration: duration,
    isUserLocked: isUserLocked,
    course: course,
    levelName: levelName,
    subjectName: subjectName,
  );
}

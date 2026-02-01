import 'package:durbar_physics/core/hive_services/hive_models/video_hive_model.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';

extension VideoToHive on VideoModel {
  VideoHiveModel toHive() => VideoHiveModel(
    id: id,
    // course: course,
    duration: duration,
    isLocked: isLocked,
    thumbnail: thumbnail,
    title: title,
    videoUrl: videoUrl,
    isUserLocked: isUserLocked,
  );
}

extension HiveToVideo on VideoHiveModel {
  VideoModel toVideo() => VideoModel(
    id: id,
    title: title,
    isLocked: isLocked,
    // course: course,
    duration: duration,
    thumbnail: thumbnail,
    videoUrl: videoUrl,
    isUserLocked: isUserLocked,
  );
}

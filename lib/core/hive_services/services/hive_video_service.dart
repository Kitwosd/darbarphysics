import 'package:durbar_physics/core/hive_services/hive_models/video_hive_model.dart';
import 'package:hive/hive.dart';

import 'package:injectable/injectable.dart';

@lazySingleton
class HiveVideoService {
  final Box<VideoHiveModel> box = Hive.box<VideoHiveModel>('videoBox');

  // add the video to box
  Future<void> addVideo(VideoHiveModel video) async {
    await box.put(video.id, video);
  }

  // remove from the box
  Future<void> removeVideo(int videoId) async {
    await box.delete(videoId);
  }

  // check if the video in the box
  bool isBookmarked(int videoId) {
    return box.containsKey(videoId);
  }

  //get all the list of vidoes
  List<VideoHiveModel> getAllVideos() {
    return box.values.toList();
  }

  //clear all the videos on logout
  Future<void> clearAll() async {
    await box.clear();
  }
}

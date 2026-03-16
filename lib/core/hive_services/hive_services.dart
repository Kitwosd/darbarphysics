import 'package:durbar_physics/core/hive_services/hive_models/course_hive_model.dart';
import 'package:durbar_physics/core/hive_services/hive_models/video_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveServices {
  static Future<void> init() async {
    //Initialize Hive
    await Hive.initFlutter();

    //Register adapters
   if (!Hive.isAdapterRegistered(2)) {
      //TODO: Hive uncomment when everything is finished
      Hive.registerAdapter(CourseHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(VideoHiveModelAdapter());
    } 

    //Open boxes
    await Hive.openBox('authBox');
    await Hive.openBox<CourseHiveModel>('courseBox');
    await Hive.openBox<VideoHiveModel>('videoBox');
  }
}

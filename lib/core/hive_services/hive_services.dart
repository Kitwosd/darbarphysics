import 'package:durbar_physics/core/hive_services/hive_models/course_hive_model.dart';
import 'package:durbar_physics/core/hive_services/hive_models/video_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveServices {
  static const int hiveVersion = 2; // 🔥 increase ONLY when schema changes

  static Future<void> init() async {
    await Hive.initFlutter();

    // ✅ Register adapters safely
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(CourseHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(VideoHiveModelAdapter());
    }

    // ✅ Open config box first (no type)
    final configBox = await Hive.openBox('configBox');

    final oldVersion = configBox.get('version');

    // 🔥 Version-based reset (ONLY when schema changes)
    if (oldVersion != hiveVersion) {
      await Hive.deleteBoxFromDisk('courseBox');
      await Hive.deleteBoxFromDisk('videoBox');

      await configBox.put('version', hiveVersion);
    }

    // ✅ Open all boxes safely
    await _openSafeBox('authBox');
    await _openSafeBox<CourseHiveModel>('courseBox');
    await _openSafeBox<VideoHiveModel>('videoBox');
  }

  // 🔥 Permanent safety net
  static Future<Box<T>> _openSafeBox<T>(String boxName) async {
    try {
      return await Hive.openBox<T>(boxName);
    } catch (e) {
      // If corrupted or schema mismatch → reset
      await Hive.deleteBoxFromDisk(boxName);
      return await Hive.openBox<T>(boxName);
    }
  }
}

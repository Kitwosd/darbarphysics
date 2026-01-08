import 'package:durbar_physics/features/live_classes/data/models/live_class_detail_model.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_model.dart';

abstract class LiveClassesRepo {
  Future<List<LiveClassModel>> getLiveClasses();
  Future<LiveClassDetailModel> getLiveClassDetail(int id);
}

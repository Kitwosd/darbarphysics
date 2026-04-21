import 'package:durbar_physics/core/network/paginated_response_model.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_detail_model.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_model.dart';

abstract class LiveClassesRepo {
  Future<PaginatedResponseModel<LiveClassModel>> getLiveClasses({int page = 1});
  Future<LiveClassDetailModel> getLiveClassDetail(int id);
}

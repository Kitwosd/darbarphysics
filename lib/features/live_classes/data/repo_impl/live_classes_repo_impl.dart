import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_detail_model.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_model.dart';
import 'package:durbar_physics/features/live_classes/domain/repos/live_classes_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LiveClassesRepo)
class LiveClassesRepoImpl implements LiveClassesRepo {
  final ApiClient apiClient;

  const LiveClassesRepoImpl(this.apiClient);

  @override
  Future<List<LiveClassModel>> getLiveClasses() async {
    final liveClasses = await apiClient.request(
      path: '/liveclass',
      method: ApiMethod.get,
    );
    final response = (liveClasses as List)
        .map((e) => LiveClassModel.fromJson(e))
        .toList();
    return response;
  }

  @override
  Future<LiveClassDetailModel> getLiveClassDetail(int id) async {
    final liveClassDetail = await apiClient.request(
      path: '/liveclass/$id',
      method: ApiMethod.get,
    );
    final response = liveClassDetail.map((e) => LiveClassModel.fromJson(e));
    return response;
  }
}

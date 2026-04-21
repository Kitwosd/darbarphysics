import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/core/network/paginated_response_model.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_detail_model.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_model.dart';
import 'package:durbar_physics/features/live_classes/domain/repos/live_classes_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LiveClassesRepo)
class LiveClassesRepoImpl implements LiveClassesRepo {
  final ApiClient apiClient;

  const LiveClassesRepoImpl(this.apiClient);

  @override
  Future<PaginatedResponseModel<LiveClassModel>> getLiveClasses({
    int page = 1,
  }) async {
    final response = await apiClient.request(
      path: '/liveclass',
      method: ApiMethod.get,
      queryParameters: {'page': page},
    );
    final liveClasses = PaginatedResponseModel<LiveClassModel>.fromJson(
      response,
      (json) => LiveClassModel.fromJson(json)
    );
    return liveClasses;
  }

  @override
  Future<LiveClassDetailModel> getLiveClassDetail(int id) async {
    final liveClassDetail = await apiClient.request(
      path: '/liveclass/$id',
      method: ApiMethod.get,
    );
    final response = LiveClassDetailModel.fromJson(liveClassDetail);

    return response;
  }
}

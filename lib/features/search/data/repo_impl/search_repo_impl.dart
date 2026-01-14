import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/features/search/data/models/search_response_model.dart';
import 'package:durbar_physics/features/search/domain/repo/search_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SearchRepo)
class SearchRepoImpl implements SearchRepo {
  final ApiClient apiClient;
  const SearchRepoImpl(this.apiClient);
  @override
  Future<SearchResponseModel> search(String query) async {
    final response = await apiClient.request(
      path: 'search/?q=$query',
      method: ApiMethod.get,
    );
    return SearchResponseModel.fromJson(response);
  }
}

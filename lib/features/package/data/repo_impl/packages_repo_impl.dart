import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/core/network/paginated_response_model.dart';
import 'package:durbar_physics/features/package/domain/repo/packages_repo.dart';
import 'package:injectable/injectable.dart';

import '../model/package_detail_model.dart';
import '../model/package_model.dart';

@Injectable(as: PackageRepo)
class PackageRepoImpl implements PackageRepo {
  final ApiClient client;

  PackageRepoImpl(this.client);

  @override
  Future<PaginatedResponseModel<PackageModel>> getPackages({int page = 1}) async {
    try {
      final response = await client.request(
        path: 'packages/',
        method: ApiMethod.get,
        queryParameters: {'page': page},
      );

      return PaginatedResponseModel<PackageModel>.fromJson(
        response,
        (json) => PackageModel.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PackageDetailModel> getPackageDetail(int id) async {
    try {
      final response = await client.request(
        path: 'packages/$id/',
        method: ApiMethod.get,
      );

      return PackageDetailModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
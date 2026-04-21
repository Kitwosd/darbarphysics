import 'package:durbar_physics/core/network/paginated_response_model.dart';
import 'package:durbar_physics/features/package/data/model/package_detail_model.dart';
import 'package:durbar_physics/features/package/data/model/package_model.dart';

abstract class PackageRepo {
  Future<PaginatedResponseModel<PackageModel>> getPackages({int page = 1});

  Future<PackageDetailModel> getPackageDetail(int id);
}
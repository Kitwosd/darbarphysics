import 'package:durbar_physics/features/search/data/models/search_response_model.dart';

abstract class SearchRepo {
  Future<SearchResponseModel> search(String query);
}

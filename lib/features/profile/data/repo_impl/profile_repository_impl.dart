import 'package:dio/dio.dart';
import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/features/profile/data/models/profile_model.dart';
import 'package:durbar_physics/features/profile/domain/repo/profile_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepo)
class ProfileRepositoryImpl implements ProfileRepo {
  final ApiClient _apiClient;

  ProfileRepositoryImpl(this._apiClient);
  @override
  Future<ProfileModel> getProfile() async {
    final response = await _apiClient.request(
      path: 'profile/',
      method: ApiMethod.get,
    );
    return ProfileModel.fromJson(response);
  }

  @override
  Future<ProfileModel> updateProfile(
    ProfileModel profile, {
    XFile? imageFile,
  }) async {
    dynamic data;

    if (imageFile != null) {
      // Need to convert all fields to String for FormData or ensure backend handles mixed types
      // Dio FormData handles standard types usually.
      // However, if we put a Map inside FormData, it might just send it as string.
      // We should spread the json.

      final Map<String, dynamic> jsonMap = profile.toJson();
      // Important: Remove 'profile_picture' string if we are sending a file
      // to avoid conflict, or maybe backend prioritizes file.
      // Let's remove it from the map if we sending a file.
      jsonMap.remove('profile_picture');

      data = FormData.fromMap({ // yo chai hamro json lai multipart/form-data ma lageko 
        ...jsonMap, //existing json format lai lerako with spread operator
        'profile_picture': await MultipartFile.fromFile( // you chai dio lai yo file ho text haina vanerw vakeo 
          imageFile.path, // yo the gallery to image path vaihalyo of image
          filename: imageFile.name, // yo chai backend le save garna use garxa 
        ),
      });
    } else {
      data = profile.toJson();
    }

    final response = await _apiClient.request(
      path: 'profile/',
      method: ApiMethod.put,
      data: data,
    );
    return ProfileModel.fromJson(response);
  }
}

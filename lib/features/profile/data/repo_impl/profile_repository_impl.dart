import 'package:dio/dio.dart';
import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/core/network/api_exception.dart';
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
    //now that the backend only accepts the form-data/multipart and not the json
    final Map<String, dynamic> jsonMap = profile.toJson();

    //remove profile_picture string always
    jsonMap.remove('profile_picture');

    final formDataMap = <String, dynamic>{};

    //add each fields sab json lai formData format ma lageko sayed except the profile_picture mathi remove garya xam
    jsonMap.forEach((key, value) {
      if (value != null) {
        formDataMap[key] = value;
      }
    });

    //add image on if selected

    if (imageFile != null) {
      formDataMap['profile_picture'] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.name,
      );
    }
    if (formDataMap.isEmpty) {
      throw ApiException(errorMessage: 'No changes to update');
    }

    dynamic data = FormData.fromMap(formDataMap); //always multipart


    final response = await _apiClient.request(
      path: 'profile/',
      method: ApiMethod.patch,
      data: data,
    );
    return ProfileModel.fromJson(response);
  }
}



    //old logic
    // if (imageFile != null) {
    //   // Need to convert all fields to String for FormData or ensure backend handles mixed types
    //   // Dio FormData handles standard types usually.
    //   // However, if we put a Map inside FormData, it might just send it as string.
    //   // We should spread the json.

    //   final Map<String, dynamic> jsonMap = profile.toJson();
    //   // Important: Remove 'profile_picture' string if we are sending a file
    //   // to avoid conflict, or maybe backend prioritizes file.
    //   // Let's remove it from the map if we sending a file.
    //   jsonMap.remove('profile_picture');

    //   data = FormData.fromMap({
    //     // yo chai hamro json lai multipart/form-data ma lageko
    //     ...jsonMap, //existing json format lai lerako with spread operator
    //     'profile_picture': await MultipartFile.fromFile(
    //       // you chai dio lai yo file ho text haina vanerw vaneko
    //       imageFile.path, // yo the gallery to image path vaihalyo of image
    //       filename: imageFile.name, // yo chai backend le save garna use garxa
    //     ),
    //   });
    // } else {
    //   data = profile.toJson();
    // }
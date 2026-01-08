import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/core/network/api_exception.dart';
import 'package:durbar_physics/features/profile/data/models/profile_model.dart';
import 'package:durbar_physics/features/profile/domain/repo/profile_repo.dart';
import 'package:durbar_physics/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepository;

  ProfileCubit(this._profileRepository) : super(ProfileState());

  Future<void> getProfile() async {
    emit(state.copyWith(status: ApiDataStatus.loading));
    try {
      final profile = await _profileRepository.getProfile();
      emit(state.copyWith(status: ApiDataStatus.success, profile: profile));
    } catch (e) {
      logger.e("Get Profile Error: $e");
      String errorMessage = "Failed to load profile";
      if (e is ApiException) {
        errorMessage = e.errorMessage;
      }
      emit(state.copyWith(status: ApiDataStatus.error, error: errorMessage));
    }
  }

  Future<void> updateProfile(ProfileModel updatedProfile) async {
    emit(state.copyWith(status: ApiDataStatus.loading));
    try {
      final profile = await _profileRepository.updateProfile(
        updatedProfile,
        imageFile: state.pickedImage,
      );
      emit(state.copyWith(status: ApiDataStatus.success, profile: profile,
      pickedImage: null));
    } catch (e) {
      logger.e("Update Profile Error: $e");
      String errorMessage = "Failed to update profile";
      if (e is ApiException) { 
        errorMessage = e.errorMessage;
      }
      emit(state.copyWith(status: ApiDataStatus.error, error: errorMessage));
    }
  }

  void setPickedImage(XFile image) {
    emit(state.copyWith(pickedImage: image));
  }
}

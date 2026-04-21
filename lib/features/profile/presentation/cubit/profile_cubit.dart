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

  Future<void> getAcademicLevels() async {
    emit(state.copyWith(academicStatus: ApiDataStatus.loading));
    try {
      final academicLevels = await _profileRepository.getAcademicLevel();
      emit(
        state.copyWith(
          academicStatus: ApiDataStatus.success,
          academics: academicLevels,
        ),
      );
    } catch (e) {
      logger.d("Error from the academic levels");
    }
  }

  Future<void> getProfile() async {
    emit(state.copyWith(status: ApiDataStatus.loading, justUpdated: false));
    try {
      final profile = await _profileRepository.getProfile();
      emit(
        state.copyWith(
          status: ApiDataStatus.success,
          profile: profile,
          justUpdated: false,
        ),
      );
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
    if (_isSameAsCurrent(updatedProfile) && state.pickedImage == null) {
      emit(
        state.copyWith(
          status: ApiDataStatus.error,
          error: 'Nothing to update',
          justUpdated: false,
        ),
      );
      return;
    }
    emit(state.copyWith(status: ApiDataStatus.loading, justUpdated: false));

    try {
      final profile = await _profileRepository.updateProfile(
        updatedProfile,
        imageFile: state.pickedImage,
      );
      emit(
        state.copyWith(
          status: ApiDataStatus.success,
          profile: profile,
          pickedImage: null,
          academicError: '',
          bioError: '',
          emailError: '',
          error: '',
          phoneError: '',
          userNameError: '',
          justUpdated: true,
        ),
      );
    } catch (e) {
      String userNameError = '';
      String phoneError = '';
      String academicError = '';
      String bioError = '';
      String emailError = '';

      String generalError = '';
      logger.e("Update Profile Error: $e");

      if (e is ApiException && e.response is Map<String, dynamic>) {
        final data = e.response as Map<String, dynamic>;

        //specific errors
        if (data.containsKey('username')) {
          userNameError = data['username'].first.toString();
        }

        if (data.containsKey('email')) {
          emailError = data['email'].first.toString();
        }

        if (data.containsKey('phone')) {
          phoneError = data['phone'].first.toString();
        }
        if (data.containsKey('bio')) {
          bioError = data['bio'].first.toString();
        }
        if (data.containsKey('academic_level')) {
          academicError = data['academic_level'].first.toString();
        }
        if (data.containsKey('profile_picture')) {
          generalError = data['profile_picture'].first.toString();
        }
        if (data.containsKey('non_field_errors')) {
          generalError = data['non_field_errors'].first.toString();
        }
      } else {
        generalError = e.toString();
      }
      emit(
        state.copyWith(
          status: ApiDataStatus.error,
          error: generalError,
          academicError: academicError,
          bioError: bioError,
          emailError: emailError,
          phoneError: phoneError,
          userNameError: userNameError,
          justUpdated: false,
        ),
      );
    }
  }

  void setPickedImage(XFile image) {
    emit(
      state.copyWith(
        pickedImage: image,
        justUpdated: false,
        status: ApiDataStatus.initial,
      ),
    );
  }

  void onUsernameChanged(String value) {
    emit(
      state.copyWith(
        userNameError: '',
        justUpdated: false,
        status: ApiDataStatus.initial,
      ),
    );
  }

  void onPhoneChanged(String value) {
    emit(
      state.copyWith(
        phoneError: '',
        justUpdated: false,
        status: ApiDataStatus.initial,
      ),
    );
  }

  void onAcademicChange(String value) {
    emit(
      state.copyWith(
        academicError: '',
        justUpdated: false,
        status: ApiDataStatus.initial,
      ),
    );
  }

  void onBioError(String value) {
    emit(
      state.copyWith(
        bioError: '',
        justUpdated: false,
        status: ApiDataStatus.initial,
      ),
    );
  }

  void onEmailError(String value) {
    emit(
      state.copyWith(
        emailError: '',
        justUpdated: false,
        status: ApiDataStatus.initial,
      ),
    );
  }

  void clearErrors() {
    emit(
      state.copyWith(
        emailError: '',
        academicError: '',
        bioError: '',
        error: '',
        phoneError: '',
        userNameError: '',
        justUpdated: false,
        status: ApiDataStatus.initial,
      ),
    );
  }

  bool _isSameAsCurrent(ProfileModel updated) {
    final current = state.profile; // This should be the ORIGINAL profile
    if (current == null) return false;

    String norm(String? v) => (v ?? '').trim();

    return norm(updated.username) == norm(current.username) &&
        norm(updated.email) == norm(current.email) &&
        norm(updated.phone) == norm(current.phone) &&
        norm(updated.bio) == norm(current.bio) &&
        updated.academicLevel == current.academicLevel;
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(status: ApiDataStatus.loading, justUpdated: false));
    try {
      await _profileRepository.deleteAccount();
      emit(state.copyWith(status: ApiDataStatus.success, justUpdated: false));
    } catch (e) {
      logger.e("Delete Account Error: $e");
      String errorMessage = "Failed to delete account";
      if (e is ApiException) {
        errorMessage = e.errorMessage;
      }
      emit(state.copyWith(status: ApiDataStatus.error, error: errorMessage));
    }
  }
}

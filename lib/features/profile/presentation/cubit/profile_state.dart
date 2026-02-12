// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/features/profile/data/models/profile_model.dart';

@injectable
class ProfileState {
  final ApiDataStatus status;
  final ProfileModel? profile;
  final String error;
  final XFile? pickedImage;
  final String userNameError;
  final String emailError;
  final String phoneError;
  final String bioError;
  final String academicError;
  final bool justUpdated;

  ProfileState({
    this.status = ApiDataStatus.initial,
    this.profile,
    this.error = '',
    this.pickedImage,
    this.userNameError = '',
    this.emailError = '',
    this.phoneError = '',
    this.bioError = '',
    this.academicError = '',
    this.justUpdated = false,
  });

  ProfileState copyWith({
    ApiDataStatus? status,
    ProfileModel? profile,
    String? error,
    XFile? pickedImage,
    String? userNameError,
    String? emailError,
    String? phoneError,
    String? bioError,
    String? academicError,
    bool? justUpdated,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      error: error ?? this.error,
      pickedImage: pickedImage ?? this.pickedImage,
      userNameError: userNameError ?? this.userNameError,
      emailError: emailError ?? this.emailError,
      phoneError: phoneError ?? this.phoneError,
      bioError: bioError ?? this.bioError,
      academicError: academicError ?? this.academicError,
      justUpdated: justUpdated ?? this.justUpdated,
    );
  }
}

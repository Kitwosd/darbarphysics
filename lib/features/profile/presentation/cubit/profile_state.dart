import 'package:durbar_physics/common/enums/enums.dart';

import 'package:durbar_physics/features/profile/data/models/profile_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileState {
  final ApiDataStatus status;
  final ProfileModel? profile;
  final String error;
  final XFile? pickedImage;

  ProfileState({
    this.status = ApiDataStatus.initial,
    this.profile,
    this.error = '',
    this.pickedImage,
  });

  ProfileState copyWith({
    ApiDataStatus? status,
    ProfileModel? profile,
    String? error,
    XFile? pickedImage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      error: error ?? this.error,
      pickedImage: pickedImage ?? this.pickedImage,
    );
  }
}

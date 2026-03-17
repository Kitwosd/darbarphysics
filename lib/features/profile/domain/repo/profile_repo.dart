import 'package:durbar_physics/features/profile/data/models/profile_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileRepo {
  Future<ProfileModel> getProfile();

  Future<ProfileModel> updateProfile(ProfileModel profile, {XFile? imageFile});

  Future<void> deleteAccount();
}

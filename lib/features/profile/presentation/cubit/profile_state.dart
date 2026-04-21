import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/features/profile/data/models/academic_model.dart';
import 'package:durbar_physics/features/profile/data/models/profile_model.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileState extends Equatable {
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
  final List<AcademicModel> academics;
  final ApiDataStatus academicStatus;

  const ProfileState({
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
    this.academics = const [],
    this.academicStatus = ApiDataStatus.initial,
  });
  // ADDED: Helper method to get academic name from ID for display purposes
  // This allows us to convert profile.academicLevel (int ID) to display name
  String? getAcademicNameById(int? id) {
    if (id == null || academics.isEmpty) return null;
    try {
      return academics.firstWhere((academic) => academic.id == id).name;
    } catch (e) {
      return null;
    }
  }

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
    List<AcademicModel>? academics,
    ApiDataStatus? academicStatus,
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
      academics: academics ?? this.academics,
      academicStatus: academicStatus ?? this.academicStatus,
    );
  }

  @override
  List<Object?> get props {
    return [
      status,
      profile,
      error,
      pickedImage,
      userNameError,
      emailError,
      phoneError,
      bioError,
      academicError,
      justUpdated,
      academics,
      academicStatus,
    ];
  }
}

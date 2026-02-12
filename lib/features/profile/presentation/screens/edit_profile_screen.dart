import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/elevated_button_widget.dart';
import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/profile_picture_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/profile/data/models/profile_model.dart';
import 'package:durbar_physics/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:durbar_physics/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileModel profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _academicLevelController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.profile.username);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _bioController = TextEditingController(text: widget.profile.bio);
    _academicLevelController = TextEditingController(
      text: widget.profile.academicLevel,
    );
    context.read<ProfileCubit>().clearErrors();
    
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _academicLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.status == ApiDataStatus.success && state.justUpdated) {
          OverlayToastWidget.show(
            message: "Profile updated successfully!",
            bgColor: Colors.green.shade300,
          );
          // Refresh main profile and go back
          getIt<ProfileCubit>().getProfile();
          NavigationService.pop(result: true);
        } else if (state.status == ApiDataStatus.error &&
            state.error.isNotEmpty) {
          OverlayToastWidget.show(
            message: state.error,
            bgColor: Colors.red.shade400,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
            leading: BackButton(
              onPressed: () {
                context.read<ProfileCubit>().getProfile();

                NavigationService.pop();
              },
            ),
            actions: [
              if (state.status == ApiDataStatus.loading)
                Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                IconButton(
                  padding: EdgeInsets.only(right: 8.w),
                  onPressed: () {
                    _saveProfile(context);
                  },
                  icon: Icon(Icons.check, color: Colors.blue, size: 32.sp),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Center(
                  // child: UserAvatar(
                  //   imageUrl: widget.profile.profilePicture,
                  //   name: _usernameController
                  //       .text, // Live update? No, use widget.profile.username or controller text if valid
                  //   radius: 50.r,
                  //   fontSize: 30.sp,
                  // ),
                  child: BlocSelector<ProfileCubit, ProfileState, String?>(
                    selector: (state) {
                      //priority on the local image over current pp
                      if (state.pickedImage != null) {
                        return state.pickedImage!.path; //local file path
                      }
                      return state
                          .profile
                          ?.profilePicture; // url from the backend
                    },
                    builder: (context, selectedValue) {
                      return ProfilePictureWidget(
                        name: _usernameController.text,
                        editButton: () async {
                          final picked = await _pickImage();
                          if (picked != null) {
                            // ignore: use_build_context_synchronously
                            context.read<ProfileCubit>().setPickedImage(picked);
                          }
                        },
                        size: 80.r,
                        pictureUrl: selectedValue,
                      );
                    },
                  ),
                ),
                20.verticalSpace,
                ElevatedButtonWidget(
                  height: 40.h,
                  width: 160.w,
                  child: TextWidget(
                    word: 'Edit Image',
                    textColor: customColors.whiteBlack,
                  ),

                  onPressed: () async {
                    final picked = await _pickImage();
                    if (picked != null) {
                      // ignore: use_build_context_synchronously
                      context.read<ProfileCubit>().setPickedImage(picked);
                    }
                  },
                ),
                10.verticalSpace,

                _buildTextField(
                  "Username",
                  _usernameController,
                  error: state.userNameError.isEmpty
                      ? null
                      : state.userNameError,
                  onChanged: (value) =>
                      context.read<ProfileCubit>().onUsernameChanged(value),
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  "Phone",
                  _phoneController,
                  keyboardType: TextInputType.phone,
                  error: state.phoneError.isEmpty ? null : state.phoneError,
                  onChanged: (value) =>
                      context.read<ProfileCubit>().onPhoneChanged(value),
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  "Academic Level",
                  _academicLevelController,
                  error: state.academicError.isEmpty
                      ? null
                      : state.academicError,
                  onChanged: (value) =>
                      context.read<ProfileCubit>().onAcademicChange(value),
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  "Bio",
                  _bioController,
                  maxLines: 3,
                  error: state.bioError.isEmpty ? null : state.bioError,
                  onChanged: (value) =>
                      context.read<ProfileCubit>().onBioError(value),
                ),
                20.verticalSpace,

                ElevatedButtonWidget(
                  bgColor: appColors.primary,
                  onPressed: state.status == ApiDataStatus.loading
                      ? null
                      : () {
                          _saveProfile(context);
                        },
                  child: state.status == ApiDataStatus.loading
                      ? CircularProgressIndicator()
                      : TextWidget(
                          word: 'Submit',
                          weight: FontWeight.w600,
                          size: 20,
                          textColor: customColors.whiteBlack,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveProfile(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    final updatedModel = ProfileModel(
      id: widget.profile.id,
      username: _usernameController.text,
      email: widget.profile.email, // Read-only usually?
      phone: _phoneController.text,
      role: widget.profile.role,
      bio: _bioController.text,
      profilePicture: widget.profile.profilePicture,
      academicLevel: _academicLevelController.text,
      course: widget.profile.course,
    );
    cubit.updateProfile(updatedModel);
  }

  Widget _buildTextField(
    String label,

    TextEditingController controller, {
    ValueChanged<String>? onChanged,
    String? error,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          word: label,
          size: 14.sp,
          textColor: Colors.grey[700],
          weight: FontWeight.w500,
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            errorText: error,
            errorMaxLines: 2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
      ],
    );
  }

  Future<XFile?> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // compress the image)
    );
    return pickedImage;
  }
}

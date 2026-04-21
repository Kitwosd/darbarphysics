import 'dart:io';

import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String name;
  final String? pictureUrl;
  final VoidCallback editButton;
  final double size;

  const ProfilePictureWidget({
    super.key,
    required this.name,
    this.pictureUrl,
    required this.editButton,
    required this.size,
  });

  String _getInitials(String name) {
    List<String> nameParts = name.trim().split(RegExp(r'\s+'));
    if (nameParts.isEmpty || nameParts[0].isEmpty) {
      return '?';
    }
    if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    } else {
      return '${nameParts[0][0]} ${nameParts[nameParts.length - 1][0]}'
          .toUpperCase();
    }
  }

  Widget _buildImage() {
    if (pictureUrl == null || pictureUrl!.isEmpty) {
      return _buildInitialWidget();
    }
    // Check if it's a network URL (http/https)
    if (pictureUrl!.startsWith('http')) {
      return CircleAvatar(
        radius: size,
        backgroundImage: NetworkImage(pictureUrl!),
      );
    }
    // Assume it's a local file path
    return CircleAvatar(
      radius: size,
      backgroundImage: FileImage(File(pictureUrl!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildImage(),
        Positioned(
          right: 0,
          bottom: 0,
          child: InkWell(
            onTap: editButton,
            child: Container(
              width: size * 1.h,
              height: size * 1.h,
              decoration: BoxDecoration(
                color: appColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.r),
              ),
              child: Icon(Icons.edit, color: Colors.white, size: size * 0.5.h),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitialWidget() {
    return CircleAvatar(
      radius: size,
      child: TextWidget(
        word: _getInitials(name),
        textColor: customColors.whiteBlack,
        size: size * 0.6.h,
        weight: FontWeight.w400,
      ),
    );
  }
}

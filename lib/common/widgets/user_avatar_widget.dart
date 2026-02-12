import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class UserAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;
  final double fontSize;

  const UserAvatarWidget({
    super.key,
    this.imageUrl,
    required this.name,
    this.radius = 40,
    this.fontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
        onBackgroundImageError: (_, __) {
          // Fallback to initials if image load fails
        },
        child: null,
      );
    }

    // Initials logic
    String initials = '';
    if (name.isNotEmpty) {
      List<String> nameParts = name.trim().split(' ');
      if (nameParts.isNotEmpty) {
        initials = nameParts[0][0].toUpperCase();
        if (nameParts.length > 1) {
          initials += nameParts[1][0].toUpperCase();
        }
      }
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.blue.shade300,
      child: TextWidget(
        word: initials,
        size: fontSize,
        weight: FontWeight.bold,
        textColor: Colors.black,
      ),
    );
  }
}

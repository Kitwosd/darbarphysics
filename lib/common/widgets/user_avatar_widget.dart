import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';

// CHANGED: converted to StatefulWidget to handle image load errors
class UserAvatarWidget extends StatefulWidget {
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
  State<UserAvatarWidget> createState() => _UserAvatarWidgetState();
}

class _UserAvatarWidgetState extends State<UserAvatarWidget> {
  bool _hasImageError = false;

  @override
  void didUpdateWidget(covariant UserAvatarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ADDED: reset error state when imageUrl changes
    if (oldWidget.imageUrl != widget.imageUrl) {
      _hasImageError = false;
    }
  }

  // Initials logic
  String get _initials {
    if (widget.name.isEmpty) return '';
    List<String> nameParts = widget.name.trim().split(' ');
    String result = nameParts[0][0].toUpperCase();
    if (nameParts.length > 1) {
      result += nameParts[1][0].toUpperCase();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final hasValidUrl =
        widget.imageUrl != null &&
        widget.imageUrl!.isNotEmpty &&
        !_hasImageError;

    if (hasValidUrl) {
      return CircleAvatar(
        radius: widget.radius,
        backgroundImage: NetworkImage(widget.imageUrl!),
        onBackgroundImageError: (_, __) {
          // CHANGED: now actually triggers fallback to initials
          if (mounted) {
            setState(() => _hasImageError = true);
          }
        },
        child: null,
      );
    }

    // Fallback: show initials
    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: Colors.blue.shade300,
      child: TextWidget(
        word: _initials,
        size: widget.fontSize,
        weight: FontWeight.bold,
        textColor: Colors.black,
      ),
    );
  }
}

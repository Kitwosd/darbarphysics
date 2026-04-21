import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PdfJumpPageDialog extends StatefulWidget {
  const PdfJumpPageDialog({super.key});

  @override
  State<PdfJumpPageDialog> createState() => _PdfJumpPageDialogState();
}

class _PdfJumpPageDialogState extends State<PdfJumpPageDialog> {
  final TextEditingController _pageController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleJump() {
    final pageNumber = int.tryParse(_pageController.text);
    if (pageNumber != null && pageNumber > 0) {
      Navigator.pop(context, pageNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: TextWidget(
        word: 'Jump to Page',
        size: 18,
        weight: FontWeight.bold,
        textColor: theme.textTheme.bodyLarge?.color,
      ),
      content: TextField(
        controller: _pageController,
        autofocus: true,
        keyboardType: TextInputType.number,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        decoration: InputDecoration(
          hintText: 'Enter page number',
          hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: theme.primaryColor, width: 2),
          ),
        ),
        onSubmitted: (_) => _handleJump(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: TextWidget(
            word: 'Cancel',
            size: 14,
            textColor: theme.textTheme.bodyMedium?.color,
          ),
        ),
        ElevatedButton(
          onPressed: _handleJump,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: TextWidget(
            word: 'Go',
            size: 14,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
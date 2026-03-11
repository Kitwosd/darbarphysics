import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PdfSearchDialog extends StatefulWidget {
  const PdfSearchDialog({super.key});

  @override
  State<PdfSearchDialog> createState() => _PdfSearchDialogState();
}

class _PdfSearchDialogState extends State<PdfSearchDialog> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    if (_searchController.text.isNotEmpty) {
      Navigator.pop(context, _searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: TextWidget(
        word: 'Search in PDF',
        size: 18,
        weight: FontWeight.bold,
        textColor: theme.textTheme.bodyLarge?.color,
      ),
      content: TextField(
        controller: _searchController,
        autofocus: true,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        decoration: InputDecoration(
          hintText: 'Enter search text',
          hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: theme.primaryColor, width: 2),
          ),
        ),
        onSubmitted: (_) => _handleSearch(),
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
          onPressed: _handleSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: TextWidget(
            word: 'Search',
            size: 14,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
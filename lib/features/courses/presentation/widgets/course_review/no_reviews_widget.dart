import 'package:flutter/material.dart';

class NoReviewsWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final double? height;
  final double? width;

  const NoReviewsWidget({
    super.key,
    this.title = 'No Reviews Yet',
    this.subtitle = 'Be the first to share your thoughts!',
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // ADDED: dark mode check
    return Container(
      height: height ?? 220,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        // CHANGED: theme-aware colors instead of hardcoded light colors
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        // END CHANGED
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Stacked chat bubble icon
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 52,
                color: Colors.indigo.shade200,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    // CHANGED: theme-aware circle background
                    color: isDark ? Colors.grey.shade800 : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.indigo.shade700 : Colors.indigo.shade100,
                    ),
                    // END CHANGED
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    size: 14,
                    color: Colors.indigo.shade300,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              // CHANGED: theme-aware text color
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 6),

          // Subtitle
          Text(
            subtitle,
            // CHANGED: theme-aware subtitle color
            style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

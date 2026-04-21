import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Optimized scroll wrapper for tabs inside NestedScrollView.
///
/// **Key differences from ScrollBarWrapperWidget:**
/// - Does NOT create its own ScrollController
/// - Relies on `primary: true` in child CustomScrollView
/// - Prevents scroll controller conflicts with NestedScrollView
/// - Eliminates jank/lag during fast scrolling
///
/// **Usage:**
/// ```dart
/// TabScrollWrapperWidget(
///   child: CustomScrollView(
///     primary: true, // MUST be true for proper coordination
///     physics: const BouncingScrollPhysics(
///       parent: AlwaysScrollableScrollPhysics(),
///     ),
///     slivers: [...],
///   ),
/// )
/// ```
///
/// **When to use:**
/// - Tabs inside NestedScrollView/TabBarView
/// - Any scrollable content with outer scroll coordination
///
/// **When NOT to use:**
/// - Standalone screens (use ScrollBarWrapperWidget instead)
/// - Screens without NestedScrollView
class TabScrollWrapperWidget extends StatelessWidget {
  /// The scrollable child widget (typically CustomScrollView)
  final Widget child;

  /// Whether to show the scrollbar while dragging
  /// Defaults to true for better user feedback
  final bool thumbVisibility;

  /// Scrollbar thickness when not being dragged
  final double? thickness;

  /// Scrollbar thickness while dragging
  final double? thicknessWhileDragging;

  /// Scrollbar corner radius
  final Radius? radius;

  const TabScrollWrapperWidget({
    super.key,
    required this.child,
    this.thumbVisibility = false,
    this.thickness,
    this.thicknessWhileDragging,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    // Use CupertinoScrollbar for consistent cross-platform behavior
    // It automatically attaches to the primary ScrollController
    return CupertinoScrollbar(
      // Rounded corners for modern UI
      radius: radius ?? Radius.circular(6.r),
      
      // Standard thickness that works well on mobile
      thickness: thickness ?? 8.w,
      
      // Don't show scrollbar by default (appears on scroll)
      thumbVisibility: thumbVisibility,
      
      // Slightly thicker when actively dragging for better grip
      thicknessWhileDragging: thicknessWhileDragging ?? 12.w,
      
      // CRITICAL: No explicit controller
      // This allows it to use the primary scroll from NestedScrollView
      // preventing controller conflicts and scroll jank
      child: child,
    );
  }
}
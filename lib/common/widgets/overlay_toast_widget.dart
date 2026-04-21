import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:flutter/material.dart';

enum ToastPosition { top, bottom }

class OverlayToastWidget {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  static void show({
    required String message,
    ToastPosition position = ToastPosition.top,
    Color bgColor = Colors.black,
    Color textColor = Colors.white,
    double borderRadius = 8,
    double size = 14,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    Duration duration = const Duration(seconds: 2),
  }) {
    // final context = NavigationService.navigationKey.currentContext;
    // if (context == null) return;

    final overlay = NavigationService.navigationKey.currentState?.overlay;
    if (overlay == null) return;

    //debounce : if toast is showing, ignore new request
    if (_isShowing) return;

    _isShowing = true;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return _ToastView(
          message: message,
          position: position,
          backgroundColor: bgColor,
          textColor: textColor,
          borderRadius: borderRadius,
          padding: padding,
          size: size,
          duration: duration,

          onToastEnd: () {
            //Reset after toast hides
            _overlayEntry?.remove();
            _overlayEntry = null;
            _isShowing = false;
          },
        );
      },
    );

    overlay.insert((_overlayEntry!));
  }
}

class _ToastView extends StatefulWidget {
  final String message;
  final ToastPosition position;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;
  final double size;
  final Duration duration;
  final VoidCallback onToastEnd;

  const _ToastView({
    required this.message,
    required this.position,
    required this.backgroundColor,
    required this.textColor,
    required this.borderRadius,
    required this.padding,
    required this.size,

    required this.onToastEnd,
    required this.duration,
  });

  @override
  State<_ToastView> createState() => _ToastViewState();
}

class _ToastViewState extends State<_ToastView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: widget.position == ToastPosition.top
          ? const Offset(0, -0.3)
          : const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(_fadeAnimation);

    //play animation forward
    _controller.forward();

    //auto dismiss after animation
    Future.delayed(widget.duration, () async {
      await _controller.reverse();
      if (!mounted) return;
      widget.onToastEnd();
    });
  }

  @override
  void dispose() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Positioned(
      top: widget.position == ToastPosition.top
          ? mediaQuery.padding.top + 16
          : null,
      bottom: widget.position == ToastPosition.bottom ? 32 : null,
      left: 16,
      right: 16,
      child: FadeTransition(
        opacity: _fadeAnimation,

        child: SlideTransition(
          position: _slideAnimation,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                child: TextWidget(
                  word: widget.message,
                  textColor: widget.textColor,
                  size: widget.size,
                  weight: FontWeight.w600,
                  maxLines: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

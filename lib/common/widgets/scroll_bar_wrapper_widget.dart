import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScrollBarWrapperWidget extends StatefulWidget {
  final Widget child;
  final ScrollController? controller;

  const ScrollBarWrapperWidget({
    super.key,
    required this.child,
    this.controller,
  });

  @override
  State<ScrollBarWrapperWidget> createState() => _ScrollBarWrapperWidgetState();
}

class _ScrollBarWrapperWidgetState extends State<ScrollBarWrapperWidget> {
  late final ScrollController _scrollController;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset > 300;

      if (shouldShow != _showScrollToTop) {
        setState(() {
          _showScrollToTop = shouldShow;
        });
      }
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CupertinoScrollbar(
          radius: Radius.circular(6.r),
          thickness: 8.w,
          thumbVisibility: false,
          thicknessWhileDragging: 12.r,
          controller: _scrollController,
          child: widget.child,
        ),

        Positioned(
          bottom: 20.h,
          right: 20.w,
          child: IgnorePointer(
            ignoring: !_showScrollToTop,
            child: AnimatedOpacity(
              opacity: _showScrollToTop ? 1 : 0,
              duration: Duration(milliseconds: 200),
              child: FloatingActionButton(
                heroTag: null,
                mini: true,
                backgroundColor: appColors.primary,

                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                  );
                },
                child: Icon(Icons.arrow_upward, size: 20.sp),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

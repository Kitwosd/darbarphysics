import 'package:flutter/material.dart';

class PaginationWrapperWidget extends StatefulWidget {
  final Widget Function(ScrollController controller) builder;
  final VoidCallback onLoadMore;
  final bool hasReachedMax;
  const PaginationWrapperWidget({
    super.key,
    required this.hasReachedMax,
    required this.onLoadMore,
    required this.builder,
  });

  @override
  State<PaginationWrapperWidget> createState() =>
      _PaginationWrapperWidgetState();
}

class _PaginationWrapperWidgetState extends State<PaginationWrapperWidget> {
  late final ScrollController _controller;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients || widget.hasReachedMax || _isFetching) return;

    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.position.pixels;

    //Load more when usesr scolls to bottom 90%
    if (currentScroll >= maxScroll * 0.9) {
      _isFetching = true;
      widget.onLoadMore();

      Future.delayed(const Duration(milliseconds: 300), () {
        _isFetching = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_controller);
  }
}

import 'dart:async';

import 'package:durbar_physics/features/search/presentation/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFieldWidget extends StatefulWidget {
  final TextEditingController searchController;
  const SearchFieldWidget({super.key, required this.searchController});

  @override
  State<SearchFieldWidget> createState() => _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends State<SearchFieldWidget> {
  Timer? _debounce;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          12.horizontalSpace,
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Theme.of(context).iconTheme.color,
                    size: 24.sp,
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: TextField(
                      controller: widget.searchController,
                      autofocus: true,
                      onChanged: (value) {
                        if (_debounce != null) {
                          if (_debounce!.isActive) {
                            _debounce!.cancel();
                          }
                        }

                        _debounce = Timer(
                          const Duration(milliseconds: 600),
                          () {
                            context.read<SearchBloc>().add(
                              GetSearchedDataEvent(query: value),
                            );
                          },
                        );
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            'Search for courses, videos, or live sessions...',
                        hintStyle: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 14.sp,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),

                  BlocSelector<SearchBloc, SearchState, String>(
                    selector: (state) {
                      return state.query;
                    },
                    builder: (context, query) {
                      if (query.isEmpty) return const SizedBox.shrink();
                      return IconButton(
                        onPressed: () {
                          widget.searchController.clear();
                          context.read<SearchBloc>().add(
                            GetSearchedDataEvent(query: ''),
                          );
                        },
                        icon: Icon(Icons.clear, size: 20.sp),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

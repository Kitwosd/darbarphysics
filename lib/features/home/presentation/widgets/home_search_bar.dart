import 'package:durbar_physics/features/search/presentation/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Theme.of(context).iconTheme.color),
              SizedBox(width: 15.w),
              Text(
                'Search here...',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 14.sp,
                ),
              ),
              // const Spacer(),
              // Icon(Icons.mic, color: Theme.of(context).primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}

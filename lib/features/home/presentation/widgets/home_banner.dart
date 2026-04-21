// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class HomeBanner extends StatelessWidget {
//   const HomeBanner({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Mock Banner Data
//     final List<String> bannerImages = [
//       'https://images.unsplash.com/photo-1546410531-bb4caa6b424d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1471&q=80',
//       'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
//       'https://images.unsplash.com/photo-1488190211105-8b0e65b80b4e?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//     ];

//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10.h),
//       child: CarouselSlider(
//         options: CarouselOptions(
//           height: 200.h,
//           autoPlay: true,
//           enlargeCenterPage: true,
//           viewportFraction: 0.8,
//           aspectRatio: 16 / 9,
//           autoPlayCurve: Curves.easeInBack,
//           enableInfiniteScroll: true,
//           // autoPlayAnimationDuration: const Duration(milliseconds: 800),
//           enlargeStrategy: CenterPageEnlargeStrategy.height,
//         ),
//         items: bannerImages.map((imageUrl) {
//           return Builder(
//             builder: (BuildContext context) {
//               return Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: EdgeInsets.symmetric(horizontal: 5.w),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15.r),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: 0.2),
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(15.r),
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.cover,
//                     errorBuilder: (ctx, err, _) => Container(
//                       color: Colors.grey[300],
//                       child: Icon(Icons.broken_image, size: 50.sp),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

import 'package:carousel_slider/carousel_slider.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/courses/presentation/bloc/banner/banner_bloc.dart';
import 'package:durbar_physics/features/home/presentation/widgets/banner_slide_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {
        final bannerItems = state.bannerItems;
        if (bannerItems.isEmpty) {
          return SizedBox.shrink();
        }
        if (state.status == ApiDataStatus.loading) {
          CircularProgressIndicator(strokeWidth: 2);
        }
        if (state.status == ApiDataStatus.success) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.h,
                    clipBehavior: Clip.none,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.easeInBack,
                    enableInfiniteScroll: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (index, _) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: bannerItems
                      .map((banner) => BannerSlideWidget(banner: banner))
                      .toList(),
                ),
                10.verticalSpace,

                //Dot Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(bannerItems.length, (index) {
                    final isActive = index == _currentIndex;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      height: 4.h,
                      clipBehavior: Clip.none,
                      width: isActive ? 22.w : 6.w,
                      decoration: BoxDecoration(
                        color: isActive
                            ? appColors.primary
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

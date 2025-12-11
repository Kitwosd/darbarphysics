import 'package:carousel_slider/carousel_slider.dart';
import 'package:dubar_physics/common/widgets/button_widget.dart';
import 'package:dubar_physics/common/widgets/text_widget.dart';
import 'package:dubar_physics/core/localization/l10_service.dart';
import 'package:dubar_physics/core/routing/navigation_service.dart';
import 'package:dubar_physics/core/routing/route_name.dart';
import 'package:dubar_physics/features/on_boarding/domain/models/on_boarding_model.dart';
import 'package:dubar_physics/features/on_boarding/presentation/widget/on_boarding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // ignore: unused_field
  int _currentPage = 0;

  List<OnBoardingModel> onBoardingPages = [
    OnBoardingModel(
      svgPath: 'assets/svg/onBoarding/on_boarding1.svg',
      title: l10.onboarding_title_1,
      subTitle: l10.onboarding_subtitle_1,
    ),
    OnBoardingModel(
      svgPath: 'assets/svg/onBoarding/on_boarding2.svg',
      title: l10.onboarding_title_2,
      subTitle: l10.onboarding_subtitle_2,
    ),
    OnBoardingModel(
      svgPath: 'assets/svg/onBoarding/on_boarding3.svg',
      title: l10.onboarding_title_3,
      subTitle: l10.onboarding_subtitle_3,
    ),
    OnBoardingModel(
      svgPath: 'assets/svg/onBoarding/on_boarding2.svg',
      title: l10.onboarding_title_4,
      subTitle: l10.onboarding_subtitle_4,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CarouselSlider.builder(
            itemCount: onBoardingPages.length,
            itemBuilder: (context, index, realIndex) {
              final page = onBoardingPages[index];
              return OnBoardingWidget(
                svgImage: page.svgPath,
                title: page.title,
                subTitle: page.subTitle,
              );
            },
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.75,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
              autoPlayInterval: Duration(seconds: 3),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(onBoardingPages.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          Spacer(),
          ButtonWidget(
            bgColor: Theme.of(context).colorScheme.primary,
            textWidget: TextWidget(
              word: 'SignUp',
              weight: FontWeight.w500,
              size: 24,
              textColor: Colors.white,
            ),
            width: 300.w,
            onPressed: () {
              NavigationService.pushNamed(RouteName.signUp);
            },
          ),
          15.verticalSpace,
          ButtonWidget(
            width: 300.w,
            textWidget: TextWidget(
              word: l10.login,
              weight: FontWeight.w500,
              size: 24.sp,
              // textColor: Colors.black,
            ),

            onPressed: () {
              NavigationService.pushNamed(RouteName.login);
            },
          ),
          30.verticalSpace,
        ],
      ),
    );
  }
}

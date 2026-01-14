import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';

import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/live_classes/presentation/bloc/live_classes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart';

class LiveClassesListScreen extends StatelessWidget {
  const LiveClassesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LiveClassesBloc>()..add(GetLiveClassesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const TextWidget(
            word: "All Live Classes",
            size: 18,
            weight: FontWeight.bold,
          ),
        ),
        body: BlocBuilder<LiveClassesBloc, LiveClassesState>(
          builder: (context, state) {
            if (state.liveClasses.isEmpty) {
              // Might be loading or empty
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.separated(
              padding: EdgeInsets.all(20.w),
              itemCount: state.liveClasses.length,
              separatorBuilder: (context, index) => SizedBox(height: 15.h),
              itemBuilder: (context, index) {
                final liveClass = state.liveClasses[index];
                return GestureDetector(
                  onTap: () {
                    
                    NavigationService.pushNamed(
                      RouteName.liveclassDetail,
                      extra: liveClass.id,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 100.w,

                          child: Image.network(
                            liveClass.thumbnail,
                            fit: BoxFit.contain,
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                word: liveClass.title,
                                overflow: TextOverflow.visible,
                                size: 16,
                                weight: FontWeight.bold,
                                textColor: customColors.greyWhite,
                              ),
                              SizedBox(height: 4.h),
                              TextWidget(
                                word: liveClass.teacherName,
                                size: 14,
                                textColor: appColors.primary,
                              ),
                              SizedBox(height: 4.h),
                              TextWidget(
                                word: DateFormat(
                                  'MMM d, h:mm a',
                                ).format(liveClass.startTime),
                                size: 12,
                                textColor: Colors.grey,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        if (liveClass.status == 'live')
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: const TextWidget(
                              word: "LIVE",
                              size: 10,
                              textColor: Colors.white,
                              weight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

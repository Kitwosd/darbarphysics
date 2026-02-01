import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/custom_appbar_Widget.dart';
import 'package:durbar_physics/common/widgets/enrollment_dialog_widget.dart';
import 'package:durbar_physics/common/widgets/error_screen.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';

import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/live_classes/presentation/bloc/live_classes_bloc.dart';
import 'package:durbar_physics/features/live_classes/presentation/widgets/live_class_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveClassesListScreen extends StatelessWidget {
  const LiveClassesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LiveClassesBloc>()..add(GetLiveClassesEvent()),
      child: Scaffold(
        appBar: CustomAppbarWidget(title: 'All Live Classes'),
        body: BlocBuilder<LiveClassesBloc, LiveClassesState>(
          builder: (context, state) {
            if (state.status == ApiDataStatus.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.status == ApiDataStatus.error) {
              return ErrorScreen(
                onGoHome: () =>
                    NavigationService.pushNamedReplacement(RouteName.home),
                onRetry: () =>
                    context.read<LiveClassesBloc>().add(GetLiveClassesEvent()),
              );
            } else if (state.status == ApiDataStatus.success) {
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
                      if (liveClass.isUserLocked) {
                        EnrollmentDialogWidget.show(context, forVideo: false);
                      }

                      NavigationService.pushNamed(
                        RouteName.liveclassDetail,
                        extra: liveClass.id,
                      );
                    },
                    child: LiveClassCardWidget(
                      liveClass: liveClass,
                      index: index,
                    ),
                  );
                },
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/error_screen.dart';
import 'package:durbar_physics/common/widgets/title_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/live_classes/presentation/bloc/live_classes_bloc.dart';
import 'package:durbar_physics/features/live_classes/presentation/widgets/claas_info_card_widget.dart';
import 'package:durbar_physics/features/live_classes/presentation/widgets/class_hero_card_widget.dart';
import 'package:durbar_physics/features/live_classes/presentation/widgets/description_card_widget.dart';
import 'package:durbar_physics/features/live_classes/presentation/widgets/live_class_action_button_widget.dart';
import 'package:durbar_physics/features/live_classes/presentation/widgets/schedule_info_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveClassDetailScreen extends StatelessWidget {
  final int id;
  const LiveClassDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<LiveClassesBloc>()..add(GetDetailLiveClassEvent(id: id)),
      child: Builder(
        builder: (BuildContext context) {
          return BlocBuilder<LiveClassesBloc, LiveClassesState>(
            builder: (context, state) {
              if (state.liveClassDetailStatus == ApiDataStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.liveClassDetailStatus == ApiDataStatus.error) {
                return ErrorScreen(
                  onGoHome: () {
                    if (!context.mounted) return;
                    return NavigationService.pushNamedReplacement(
                      RouteName.home,
                    );
                  },
                  onRetry: () => context.read<LiveClassesBloc>().add(
                    GetDetailLiveClassEvent(id: id),
                  ),
                );
              } else if (state.liveClassDetailStatus == ApiDataStatus.success) {
                if (state.liveClassDetail != null) {
                  return Scaffold(
                    // appBar: AppBar(
                    //   backgroundColor: Colors.transparent,
                    //   elevation: 0,
                    //   leading: IconButton(
                    //     icon: Icon(
                    //       Icons.arrow_back_ios,
                    //       color: Theme.of(context).iconTheme.color,
                    //     ),
                    //     onPressed: () => Navigator.pop(context),
                    //   ),
                    //   title: Text(
                    //     'Class Details',
                    //     style: TextStyle(
                    //       color: Theme.of(context).textTheme.bodyLarge?.color,
                    //       fontSize: 18.sp,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    body: SafeArea(
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TitleWidget(
                                    title: state.liveClassDetail!.title,
                                  ),
                                  10.verticalSpace,
                                  ClassHeroCardWidget(
                                    liveClass: state.liveClassDetail!,
                                  ),
                                  16.verticalSpace,
                                  ScheduleInfoCardWidget(
                                    liveClass: state.liveClassDetail!,
                                  ),
                                  16.verticalSpace,
                                  ClassInfoCardWidget(
                                    liveClass: state.liveClassDetail!,
                                  ),
                                  16.verticalSpace,
                                  DescriptionCardWidget(
                                    liveClass: state.liveClassDetail!,
                                  ),
                                  100.verticalSpace,
                                ],
                              ),
                            ),
                          ),
                          LiveClassActionButtonWidget(
                            liveClass: state.liveClassDetail!,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              } else {
                return SizedBox.shrink();
              }
              return SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}

import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/error_screen.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/courses/presentation/bloc/courses/courses_bloc.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_detail_header.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_info_section.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_lessons_tab.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_live_tab.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_overview_tab.dart';
import 'package:durbar_physics/features/payment/data/services/khalti_service.dart';
import 'package:durbar_physics/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:durbar_physics/features/payment/presentation/widget/payment_status_dialog_widget.dart';
import 'package:durbar_physics/features/payment/presentation/widget/verifying_dialog_widget.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseDetailScreen extends StatefulWidget {
  final int courseId;
  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final KhaltiService _khaltiService = getIt<KhaltiService>();
  bool isKhaltiOpened = false;

  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(
      GetCourseDetailEvent(courseId: widget.courseId),
    );
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onPaymentStateChanged(
    BuildContext context,
    PaymentState state,
  ) async {
    // step 1 success: Got pidx => open khalti

    if (state.initializeStatus == ApiDataStatus.success &&
        state.pidx != null &&
        !isKhaltiOpened) {
      isKhaltiOpened = true;
      logger.i('Got pidx, opening khalti....');

      //Open khalti sdk - UI responsibility

      final resultPidx = await _khaltiService.openPayment(
        context: context,
        pidx: state.pidx!,
      );

      if (!context.mounted) return;

      if (resultPidx != null) {
        //// ✅ Payment done on Khalti → Tell bloc to verify
        logger.i('Khalti success, verifying with backend...');
        context.read<PaymentBloc>().add(VerifyPaymentEvent(pidx: resultPidx));
      } else {
        //User canceled or error. So reset silently
        isKhaltiOpened = false;

        logger.i('User cancelled or failed. resetting......');
        context.read<PaymentBloc>().add(ResetStatesEvent());
      }
      return;
    }

    // Step 2: Verifying -> showing verifying dialog
    if (state.verifyStatus == ApiDataStatus.loading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const VerifyingDialogWidget(),
      );
      return;
    }

    //Step 3a: Verify Success -> Close dialog, show success
    if (state.verifyStatus == ApiDataStatus.success) {
      //close verifying dialog
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      await PaymentStatusDialogWidget.show(
        isSuccess: true,
        message: state.successMessage,
        context: context,
        onContinue: () {
          //refresh course to unlock the content
          context.read<CoursesBloc>().add(
            GetCourseDetailEvent(courseId: widget.courseId),
          );
          isKhaltiOpened = false;
          context.read<PaymentBloc>().add(ResetStatesEvent());
          // NavigationService.pop();
        },
      );
      return;
    }

    // step 3b: Verify failed -> Close dialog, show error
    if (state.verifyStatus == ApiDataStatus.error) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      await PaymentStatusDialogWidget.show(
        context: context,
        isSuccess: false,
        message: state.errorMessage,
        details: state.detailErrorMessage.isNotEmpty
            ? state.detailErrorMessage
            : null,
        onContinue: () {
          isKhaltiOpened = false;
          context.read<PaymentBloc>().add(ResetStatesEvent());
          // NavigationService.pop();
        },
      );
      return;
    }

    // finally when initialization failed -> show error
    if (state.initializeStatus == ApiDataStatus.error) {
      await PaymentStatusDialogWidget.show(
        context: context,
        isSuccess: false,
        message: state.errorMessage,
        onContinue: () {
          isKhaltiOpened = false;
          context.read<PaymentBloc>().add(ResetStatesEvent());
          // NavigationService.pop();
        },
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: _onPaymentStateChanged,
      child: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          // Loading
          if (state.courseDetailStatus == ApiDataStatus.loading ||
              state.courseDetailStatus == ApiDataStatus.initial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          //error
          if (state.courseDetailStatus == ApiDataStatus.error ||
              state.course == null) {
            return ErrorScreen(
              errorMessage: state.error.isNotEmpty
                  ? state.error
                  : 'Failed to load course details',

              onGoHome: () => NavigationService.pushNamed(RouteName.home),
              onRetry: () => context.read<CoursesBloc>().add(
                GetCourseDetailEvent(courseId: widget.courseId),
              ),
            );
          }

          final course = state.course!;

          return Scaffold(
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: ExtendedNestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverToBoxAdapter(
                      child: RepaintBoundary(
                        child: CourseDetailHeader(course: course),
                      ),
                    ),

                    // SliverOverlapAbsorber(
                    //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    //     context,
                    //   ),
                    //   sliver: SliverPersistentHeader(
                    //     pinned: true,
                    //     delegate: _CourseInfoDelegate(
                    //       child: SafeArea(
                    //         top: true,
                    //         child: CourseInfoSection(course: course),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SliverToBoxAdapter(
                      child: RepaintBoundary(
                        child: CourseInfoSection(course: course),
                      ),
                    ),
                    SliverOverlapAbsorber(
                      handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                      sliver: SliverPersistentHeader(
                        pinned: true,
                        delegate: _TabBarDelegate(
                          child: SafeArea(
                            top: true,
                            child: Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: TabBar(
                                controller: _tabController,
                                labelColor: appColors.primary,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor: appColors.primary,
                                labelStyle: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                                unselectedLabelStyle: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                tabs: const [
                                  Tab(text: 'Overview'),
                                  Tab(text: 'Lesson'),
                                  Tab(text: 'Live'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  body: SafeArea(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        CourseOverviewTab(course: course),
                        CourseLessonsTab(course: course),
                        CourseLiveTab(course: course),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: state.course!.isUserLocked
                ? _buildEnrollButton(course)
                : null,
          );
        },
      ),
    );
  }
  // ─────────────────────────────────────────────────
  // Enroll button
  // Disabled during any payment step
  // ─────────────────────────────────────────────────

  Widget _buildEnrollButton(course) {
    //Free course - no button
    if ((double.tryParse(course.cost) ?? 0) <= 0) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          final isProcessing =
              state.initializeStatus == ApiDataStatus.loading ||
              state.verifyStatus == ApiDataStatus.loading;
          return ElevatedButton(
            onPressed: isProcessing
                ? null
                : () => context.read<PaymentBloc>().add(
                    InitializePaymentEvent(courseId: widget.courseId),
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            child: isProcessing
                ? SizedBox(
                    child: SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          customColors.whiteBlack,
                        ),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const TextWidget(
                        word: 'Enroll Now - Rs. ',
                        size: 18,
                        textColor: Colors.white,
                        weight: FontWeight.bold,
                      ),
                      TextWidget(
                        word: course.cost,
                        size: 18,
                        textColor: Colors.white,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _TabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 48.0.h;

  @override
  double get minExtent => 48.0.h;

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return false;
  }
}

// ignore: unused_element
class _CourseInfoDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _CourseInfoDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 225.h;

  @override
  double get minExtent => 225.h;

  @override
  bool shouldRebuild(_CourseInfoDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}

//

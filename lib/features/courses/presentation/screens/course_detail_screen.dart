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
            body: SafeArea(
              child: Column(
                children: [
                  CourseDetailHeader(course: course),
                  Expanded(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        CourseInfoSection(course: course),
                      ],
                      body: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            labelColor: appColors.primary,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: appColors.primary,
                            tabs: const [
                              Tab(text: 'Overview'),
                              Tab(text: 'Lessons'),
                              Tab(text: 'Live'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                CourseOverviewTab(course: course),
                                CourseLessonsTab(course: course),
                                CourseLiveTab(course: course),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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














//Talw to chai paila ko working khalti ko code


// import 'package:durbar_physics/common/enums/enums.dart';
// import 'package:durbar_physics/common/widgets/text_widget.dart';
// import 'package:durbar_physics/core/di/injection.dart';
// import 'package:durbar_physics/core/routing/navigation_service.dart';
// import 'package:durbar_physics/core/services/app_globals.dart';
// import 'package:durbar_physics/features/courses/presentation/bloc/courses/courses_bloc.dart';
// import 'package:durbar_physics/features/courses/presentation/widgets/course_detail_header.dart';
// import 'package:durbar_physics/features/courses/presentation/widgets/course_info_section.dart';
// import 'package:durbar_physics/features/courses/presentation/widgets/course_lessons_tab.dart';
// import 'package:durbar_physics/features/courses/presentation/widgets/course_live_tab.dart';
// import 'package:durbar_physics/features/courses/presentation/widgets/course_overview_tab.dart';
// import 'package:durbar_physics/features/courses/presentation/widgets/verifying_dialog_widget.dart';
// import 'package:durbar_physics/features/payment/data/services/khalti_payment_service.dart';
// import 'package:durbar_physics/features/payment/presentation/widget/payment_status_dialog_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CourseDetailScreen extends StatefulWidget {
//   final int courseId;
//   const CourseDetailScreen({super.key, required this.courseId});
//   @override
//   State<CourseDetailScreen> createState() => _CourseDetailScreenState();
// }

// class _CourseDetailScreenState extends State<CourseDetailScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final KhaltiPaymentService _paymentService = getIt<KhaltiPaymentService>();
//   bool _isProcessing = false;
//   @override
//   void initState() {
//     super.initState();
//     context.read<CoursesBloc>().add(
//       GetCourseDetailEvent(courseId: widget.courseId),
//     );
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   // Future<void> _handleEnrollment() async {
//   //   if (_isProcessing) return;
//   //   final course = context.read<CoursesBloc>().state.course;
//   //   if (course == null) return;
//   //   setState(() {
//   //     _isProcessing = true;
//   //   });
//   //   try {
//   //     //Step 2: Get pidx from Khalti API (using real API call)
//   //     final initiateReponse = await _paymentService.initializePayment(
//   //       courseId: widget.courseId,
//   //     );
//   //     if (!initiateReponse.success || initiateReponse.pidx == null) {
//   //       throw Exception(
//   //         initiateReponse.errorMessage ?? 'Failed to initialize the payment',
//   //       );
//   //     }
//   //     if (!mounted) return;
//   //     //step 3: Process payment with khalti
//   //     final paymentResult = await _paymentService.processPayment(
//   //       context: context,
//   //       pidx: initiateReponse.pidx!,
//   //     );
//   //     if (!mounted) return;
//   //     //Step 4: Handle payment result
//   //     if (paymentResult.success) {
//   //       // Verify payment on backend

//   //       /// 'Verifying ... 'dialog

//   //       showDialog(
//   //         context: context,
//   //         barrierDismissible: false,
//   //         builder: (context) => VerifyingDialogWidget(),
//   //       );

//   //       //Verify paymement(with retry logic -may take 10-30 seconds)
//   //       final verified = await _paymentService.verifyPaymentOnBackend(
//   //         pidx:
//   //             initiateReponse.pidx!, // Use the pidx that initiated the payment
//   //       );
//   //       if (!mounted) return;

//   //       //close verifying dialog
//   //       Navigator.of(context).pop();

//   //       //show result
//   //       if (verified.isSucess) {
//   //         await PaymentStatusDialogWidget.show(
//   //           context: context,
//   //           isSuccess: true,
//   //           message: verified.status ?? 'Enrollment succesful',
//   //           details:
//   //               'You can now access all course content. \n Transaction ID: ${paymentResult.transactionId ?? 'N/A'}',
//   //           onContinue: () {
//   //             // Refresh the course details to update UI (remove lock, hide enroll, etc.)
//   //             context.read<CoursesBloc>().add(
//   //               GetCourseDetailEvent(courseId: widget.courseId),
//   //             );
//   //             // Close the dialog
//   //             NavigationService.pop();
//   //           },
//   //         );
//   //       } else {
//   //         // ❌ FAILED or TIMEOUT
//   //         await PaymentStatusDialogWidget.show(
//   //           context: context,
//   //           isSuccess: false,
//   //           message: verified.errorMessage ?? 'Payment verification failed',
//   //           details:
//   //               '${verified.errorMessage ?? "Could not verify payment"}\n\n'
//   //               'If money was deducted, please contact support with:\n'
//   //               'Transaction ID: ${paymentResult.transactionId ?? "N/A"}',
//   //         );
//   //       }
//   //     } else {
//   //       await PaymentStatusDialogWidget.show(
//   //         context: context,
//   //         isSuccess: false,
//   //         message: paymentResult.errorMessage ?? 'Payment Failed ',
//   //       );
//   //     }
//   //   } catch (e) {
//   //     if (mounted) {
//   //       await PaymentStatusDialogWidget.show(
//   //         context: context,
//   //         isSuccess: false,
//   //         message: 'An error occured',
//   //         details: e.toString(),
//   //       );
//   //     }
//   //   } finally {
//   //     if (mounted) {
//   //       setState(() {
//   //         _isProcessing = false;
//   //       });
//   //     }
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CoursesBloc, CoursesState>(
//       builder: (context, state) {
//         if (state.courseDetailStatus == ApiDataStatus.loading ||
//             state.courseDetailStatus == ApiDataStatus.initial) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (state.courseDetailStatus == ApiDataStatus.error) {
//           return Scaffold(
//             body: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextWidget(
//                     word: state.error.isNotEmpty
//                         ? state.error
//                         : 'Failed to load course details',
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.read<CoursesBloc>().add(
//                         GetCourseDetailEvent(courseId: widget.courseId),
//                       );
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         if (state.course == null) {
//           return const Scaffold(
//             body: Center(child: TextWidget(word: 'Course not found')),
//           );
//         }

//         final course = state.course!;
//         //         return BlocListener<BookmarkBloc, BookmarkState>(
//         // listener: (context, state) {
//         //   final isBookmarked = state.bookmarkIds.contains(course.id);
//         //   ScaffoldMessenger.of(context).showSnackBar(
//         //     SnackBar(
//         //       content: Text(
//         //         isBookmarked ? 'Added to Bookmark' : 'Removed from bookmark',
//         //       ),
//         //     ),
//         //   );
//         // },
//         return Scaffold(
//           body: SafeArea(
//             child: Column(
//               children: [
//                 CourseDetailHeader(course: course),
//                 Expanded(
//                   child: NestedScrollView(
//                     headerSliverBuilder: (context, innerBoxIsScrolled) => [
//                       CourseInfoSection(course: course),
//                     ],
//                     body: Column(
//                       children: [
//                         TabBar(
//                           controller: _tabController,
//                           labelColor: appColors.primary,
//                           unselectedLabelColor: Colors.grey,
//                           indicatorColor: appColors.primary,
//                           tabs: const [
//                             Tab(text: "Overview"),
//                             Tab(text: "Lessons"),
//                             Tab(text: 'Live'),
//                           ],
//                         ),
//                         Expanded(
//                           child: TabBarView(
//                             controller: _tabController,
//                             children: [
//                               CourseOverviewTab(course: course),
//                               CourseLessonsTab(course: course),
//                               CourseLiveTab(course: course),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           bottomNavigationBar: Padding(
//             padding: EdgeInsets.all(20.w),
//             child: (double.tryParse(course.cost) ?? 0) <= 0
//                 ? const SizedBox.shrink() // Hide button if free
//                 : ElevatedButton(
//                     onPressed: _isProcessing ? null : _handleEnrollment,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Theme.of(context).primaryColor,
//                       padding: EdgeInsets.symmetric(vertical: 15.h),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.r),
//                       ),
//                     ),
//                     child: _isProcessing
//                         ? SizedBox(
//                             height: 20.h,
//                             width: 20.w,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 customColors.whiteBlack,
//                               ),
//                             ),
//                           )
//                         : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const TextWidget(
//                                 word: "Enroll Now - Rs. ",
//                                 size: 18,
//                                 textColor: Colors.white,
//                                 weight: FontWeight.bold,
//                               ),
//                               TextWidget(
//                                 word: course.cost,
//                                 size: 18,
//                                 textColor: Colors.white,
//                                 weight: FontWeight.bold,
//                               ),
//                             ],
//                           ),
//                   ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/courses/presentation/courses/courses_bloc.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_detail_header.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_info_section.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_lessons_tab.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_overview_tab.dart';
import 'package:durbar_physics/features/payment/data/models/payment_initiate_request_model.dart';
import 'package:durbar_physics/features/payment/data/services/khalti_payment_service.dart';
import 'package:durbar_physics/features/payment/presentation/widget/payment_status_dialog_widget.dart';
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
  final KhaltiPaymentService _paymentService = getIt<KhaltiPaymentService>();
  bool _isProcessing = false;
  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(
      GetCourseDetailEvent(courseId: widget.courseId),
    );
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleEnrollment() async {
    if (_isProcessing) return;
    final course = context.read<CoursesBloc>().state.course;
    if (course == null) return;
    setState(() {
      _isProcessing = true;
    });
    try {
      //Step 1: Create payment request
      final paymentRequest = PaymentInitiateRequestModel.fromCourse(
        courseId: course.id.toString(),
        courseName: course.title,
        userId: 'user_test_123',
        priceInRupees: double.parse(course.cost),
        userName: 'Test Name',
        userEmail: 'Devsubedi@gmail.com',
        userPhone: '9813291653',
      );
      //Step 2: Get pidx from Khalti API (using real API call)
      final initiateReponse = await _paymentService.initializePayment(
        request: paymentRequest,
        useMock: false, // Using real Khalti API
      );
      if (!initiateReponse.success || initiateReponse.pidx == null) {
        throw Exception(
          initiateReponse.errorMessage ?? 'Failed to initialize the payment',
        );
      }
      if (!mounted) return;
      //step 3: Process payment with khalti
      final paymentResult = await _paymentService.processPayment(
        context: context,
        pidx: initiateReponse.pidx!,
      );
      if (!mounted) return;
      //Step 4: Handle payment result
      if (paymentResult.success) {
        //When backend is ready, verify payment
        //final verified = await _paymentService.verifyPaymentOnBackend(
        // pidx: paymentResult.pidx!);
        await PaymentStatusDialogWidget.show(
          context: context,
          isSuccess: true,
          message: 'Enrollment succesful!',
          details: 'Transaction ID: ${paymentResult.transactionId ?? 'N/A'}',
          onContinue: () {
            // TODO: Navigate to course content
            // And refresh enrolled courses to remove the lock sign and have accessed to video
            NavigationService.pop();
          },
        );
      } else {
        await PaymentStatusDialogWidget.show(
          context: context,
          isSuccess: false,
          message: paymentResult.errorMessage ?? 'Payment Failed',
        );
      }
    } catch (e) {
      if (mounted) {
        await PaymentStatusDialogWidget.show(
          context: context,
          isSuccess: false,
          message: 'An error occured',
          details: e.toString(),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state.courseDetailStatus == ApiDataStatus.loading ||
            state.courseDetailStatus == ApiDataStatus.initial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.courseDetailStatus == ApiDataStatus.error) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    word: state.error.isNotEmpty
                        ? state.error
                        : 'Failed to load course details',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CoursesBloc>().add(
                        GetCourseDetailEvent(courseId: widget.courseId),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.course == null) {
          return const Scaffold(
            body: Center(child: TextWidget(word: 'Course not found')),
          );
        }

        final course = state.course!;
        //         return BlocListener<BookmarkBloc, BookmarkState>(
          // listener: (context, state) {
          //   final isBookmarked = state.bookmarkIds.contains(course.id);
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(
          //         isBookmarked ? 'Added to Bookmark' : 'Removed from bookmark',
          //       ),
          //     ),
          //   );
          // },
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
                            Tab(text: "Overview"),
                            Tab(text: "Lessons"),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              CourseOverviewTab(course: course),
                              CourseLessonsTab(course: course),
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
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(20.w),
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _handleEnrollment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: _isProcessing
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          customColors.whiteBlack,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const TextWidget(
                          word: "Enroll Now - Rs. ",
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
            ),
          ),
        );
      },
    );
  }
}

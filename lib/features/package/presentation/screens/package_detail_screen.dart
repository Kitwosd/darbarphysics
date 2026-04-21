import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/custom_appbar_widget.dart';
import 'package:durbar_physics/common/widgets/error_screen.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/features/package/presentation/bloc/package_detail/package_detail_bloc.dart';
import 'package:durbar_physics/features/package/presentation/bloc/package_detail/package_detail_event.dart';
import 'package:durbar_physics/features/package/presentation/bloc/package_detail/package_detail_state.dart';
import 'package:durbar_physics/features/package/presentation/widgets/package_detail/package_detail_bottom_bar.dart';
import 'package:durbar_physics/features/package/presentation/widgets/package_detail/package_detail_courses_tab.dart';
import 'package:durbar_physics/features/package/presentation/widgets/package_detail/package_detail_header.dart';
import 'package:durbar_physics/features/package/presentation/widgets/package_detail/package_detail_overview_tab.dart';
import 'package:durbar_physics/features/package/presentation/widgets/package_detail/package_detail_stats_bar.dart';
import 'package:durbar_physics/features/payment/data/services/khalti_service.dart';
import 'package:durbar_physics/features/payment/presentation/package_payment_bloc/package_payment_bloc.dart';
import 'package:durbar_physics/features/payment/presentation/package_payment_bloc/package_payment_event.dart';
import 'package:durbar_physics/features/payment/presentation/widget/payment_status_dialog_widget.dart';
import 'package:durbar_physics/features/payment/presentation/widget/verifying_dialog_widget.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PackageDetailScreen extends StatefulWidget {
  final int packageId;

  const PackageDetailScreen({super.key, required this.packageId});

  @override
  State<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final KhaltiService _khaltiService = getIt<KhaltiService>();
  bool isKhaltiOpened = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onPaymentStateChanged(
    BuildContext context,
    PackagePaymentState state,
  ) async {
    if (state.initializeStatus == ApiDataStatus.success &&
        state.pidx != null &&
        !isKhaltiOpened) {
      isKhaltiOpened = true;
      logger.i('Got package pidx, opening khalti....');

      final resultPidx = await _khaltiService.openPayment(
        context: context,
        pidx: state.pidx!,
      );

      if (!context.mounted) return;

      if (resultPidx != null) {
        logger.i('Khalti success, verifying package with backend...');
        context.read<PackagePaymentBloc>().add(VerifyPackagePaymentEvent(pidx: resultPidx));
      } else {
        isKhaltiOpened = false;
        logger.i('User cancelled or failed package. resetting......');
        context.read<PackagePaymentBloc>().add(ResetPackageStatesEvent());
      }
      return;
    }

    if (state.verifyStatus == ApiDataStatus.loading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const VerifyingDialogWidget(),
      );
      return;
    }

    if (state.verifyStatus == ApiDataStatus.success) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      await PaymentStatusDialogWidget.show(
        isSuccess: true,
        message: state.successMessage,
        context: context,
        onContinue: () {
          context.read<PackageDetailBloc>().add(
            GetPackageDetailEvent(packageId: widget.packageId),
          );
          isKhaltiOpened = false;
          context.read<PackagePaymentBloc>().add(ResetPackageStatesEvent());
        },
      );
      return;
    }

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
          context.read<PackagePaymentBloc>().add(ResetPackageStatesEvent());
        },
      );
      return;
    }

    if (state.initializeStatus == ApiDataStatus.error) {
      await PaymentStatusDialogWidget.show(
        context: context,
        isSuccess: false,
        message: state.errorMessage,
        onContinue: () {
          isKhaltiOpened = false;
          context.read<PackagePaymentBloc>().add(ResetPackageStatesEvent());
        },
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<PackageDetailBloc>()
            ..add(GetPackageDetailEvent(packageId: widget.packageId)),
        ),
        BlocProvider(
          create: (context) => getIt<PackagePaymentBloc>(),
        ),
      ],
      child: BlocListener<PackagePaymentBloc, PackagePaymentState>(
        listener: _onPaymentStateChanged,
        child: Scaffold(
          appBar: const CustomAppbarWidget(
          title: 'Package Details',
          actions: [
            // IconButton(
            //   icon: Icon(Icons.share_outlined),
            //   onPressed: null, // To be implemented
            // ),
          ],
        ),
        body: BlocBuilder<PackageDetailBloc, PackageDetailState>(
          builder: (context, state) {
            if (state.status == ApiDataStatus.loading ||
                state.status == ApiDataStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ApiDataStatus.error || state.package == null) {
              return ErrorScreen(
                errorMessage: state.errorMessage,
                onRetry: () => context.read<PackageDetailBloc>().add(
                  GetPackageDetailEvent(packageId: widget.packageId),
                ),
                onGoHome: () => Navigator.of(context).pop(),
              );
            }

            final package = state.package!;

            return ExtendedNestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      PackageDetailHeader(package: package),
                      PackageDetailStatsBar(package: package),
                      20.verticalSpace,
                    ],
                  ),
                ),
                SliverOverlapAbsorber(
                  handle:
                      ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                  sliver: SliverPersistentHeader(
                    pinned: true,
                    delegate: _TabBarDelegate(
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Theme.of(context).primaryColor,
                          labelStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: const [
                            Tab(text: "Overview"),
                            Tab(text: "Courses"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  PackageDetailOverviewTab(package: package),
                  PackageDetailCoursesTab(package: package),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<PackageDetailBloc, PackageDetailState>(
          builder: (context, state) {
            if (state.package != null) {
              return PackageDetailBottomBar(package: state.package!);
            }
            return const SizedBox.shrink();
          },
        ),
        ),
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
  double get maxExtent => 48.h;

  @override
  double get minExtent => 48.h;

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return false;
  }
}

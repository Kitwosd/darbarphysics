import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/custom_appbar_widget.dart';
import 'package:durbar_physics/common/widgets/error_screen.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/features/package/presentation/bloc/package_detail/package_detail_bloc.dart';
import 'package:durbar_physics/features/package/presentation/bloc/package_detail/package_detail_event.dart';
import 'package:durbar_physics/features/package/presentation/bloc/package_detail/package_detail_state.dart';
import 'package:durbar_physics/features/package/presentation/widgets/package_detail/package_detail_bottom_bar.dart';
import 'package:durbar_physics/features/package/presentation/widgets/package_detail/package_detail_courses_tab.dart';
import 'package:durbar_physics/features/package/presentation/widgets/package_detail/package_detail_header.dart';
import 'package:durbar_physics/features/package/presentation/widgets/package_detail/package_detail_overview_tab.dart';
import 'package:durbar_physics/features/package/presentation/widgets/package_detail/package_detail_stats_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<PackageDetailBloc>()
            ..add(GetPackageDetailEvent(packageId: widget.packageId)),
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

import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/custom_appbar_widget.dart';
import 'package:durbar_physics/common/widgets/scroll_bar_wrapper_widget.dart';
import 'package:durbar_physics/common/widgets/services/pagination_wrapper_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/package/presentation/bloc/packages_bloc.dart';
import 'package:durbar_physics/features/package/presentation/bloc/packages_event.dart';
import 'package:durbar_physics/features/package/presentation/bloc/packages_state.dart';
import 'package:durbar_physics/features/package/presentation/widgets/package_all_screen_widgets/empty_package_state.dart';
import 'package:durbar_physics/features/package/presentation/widgets/package_all_screen_widgets/package_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AllPackagesScreen extends StatelessWidget {
  const AllPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PackageBloc>()..add(GetPackagesEvent()),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppbarWidget(
          title: 'All Packages',
          actions: [
            BlocBuilder<PackageBloc, PackageState>(
              builder: (context, state) {
                return PopupMenuButton<PackageSortOrder>(
                  icon: Icon(Icons.sort, color: Theme.of(context).iconTheme.color),
                  onSelected: (sortOrder) {
                    context.read<PackageBloc>().add(ChangeSortEvent(sortOrder));
                  },
                  itemBuilder: (context) => [
                    _buildSortMenuItem(context, PackageSortOrder.newest, 'Newest', Icons.new_releases, state.sortOrder),
                    _buildSortMenuItem(context, PackageSortOrder.priceLowToHigh, 'Price: Low to High', Icons.arrow_upward, state.sortOrder),
                    _buildSortMenuItem(context, PackageSortOrder.priceHighToLow, 'Price: High to Low', Icons.arrow_downward, state.sortOrder),
                    _buildSortMenuItem(context, PackageSortOrder.mostPopular, 'Most Popular', Icons.trending_up, state.sortOrder),
                  ],
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Divider(color: Theme.of(context).dividerColor, height: 1),
              Expanded(
                child: BlocBuilder<PackageBloc, PackageState>(
                  builder: (context, state) {
                    if (state.status == ApiDataStatus.loading && state.packages.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (state.status == ApiDataStatus.error && state.packages.isEmpty) {
                      return Center(child: Text(state.errorMessage));
                    }

                    final packages = state.filteredAndSortedPackages;

                    if (packages.isEmpty && state.status == ApiDataStatus.success) {
                      return const EmptyPackagesState();
                    }

                    return PaginationWrapperWidget(
                      onLoadMore: () {
                        context.read<PackageBloc>().add(LoadMorePackagesEvent());
                      },
                      hasReachedMax: state.hasReachedMax,
                      builder: (ScrollController controller) {
                        return ScrollBarWrapperWidget(
                          controller: controller,
                          child: ListView.separated(
                            controller: controller,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            itemCount: packages.length,
                            separatorBuilder: (context, index) => SizedBox(height: 16.h),
                            itemBuilder: (context, index) {
                              final package = packages[index];
                              return PackageListCard(
                                package: package,
                                onTap: () {
                                  context.pushNamed(
                                    RouteName.packageDetail,
                                    extra: package.id,
                                  );
                                },
                                onEnroll: () {
                                  context.pushNamed(
                                    RouteName.packageDetail,
                                    extra: package.id,
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<PackageSortOrder> _buildSortMenuItem(
    BuildContext context,
    PackageSortOrder value,
    String label,
    IconData icon,
    PackageSortOrder currentSort,
  ) {
    final isSelected = currentSort == value;
    return PopupMenuItem<PackageSortOrder>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).iconTheme.color?.withValues(alpha:0.7),
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
          ),
        ],
      ),
    );
  }
}

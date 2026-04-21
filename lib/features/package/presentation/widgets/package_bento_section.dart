import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/package/data/model/package_model.dart';
import 'package:durbar_physics/features/package/presentation/bloc/packages_bloc.dart';
import 'package:durbar_physics/features/package/presentation/bloc/packages_state.dart';
import 'package:durbar_physics/features/package/presentation/widgets/package_feature_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/package_more_card.dart';
import '../widgets/package_small_card.dart';

class PackagesBentoSection extends StatelessWidget {
  const PackagesBentoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackageBloc, PackageState>(
      builder: (context, state) {
        if (state.status == ApiDataStatus.loading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state.status == ApiDataStatus.error) {
          return Center(child: Text(state.errorMessage));
        }
        if (state.status == ApiDataStatus.success) {
          final packages = state.packages;
          return _buildContent(context, packages);
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildContent(BuildContext context, List<PackageModel> packages) {
    // Get featured package (first one or the one marked as featured)
    final featuredPackage = packages.isNotEmpty ? packages[0] : null;

    // Get other packages (remaining ones)
    final otherPackages = packages.length > 1 ? packages.sublist(1) : [];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          // _buildSectionHeader(context, packages.length),

          // Bento Grid Layout
          SizedBox(
            height: 452.h, // Total height: 280 + 160 + 12 (gap)
            child: Row(
              children: [
                // Left Side: Featured Package (spans full height)
                Expanded(
                  flex: 3,
                  child: featuredPackage != null
                      ? PackageFeaturedCard(
                          package: featuredPackage,
                          onTap: () =>
                              _handlePackageTap(context, featuredPackage),
                          onEnroll: () =>
                              _handleEnrollTap(context, featuredPackage),
                        )
                      : const SizedBox.shrink(),
                ),

                SizedBox(width: 12.w),

                // Right Side: Stacked Cards
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Top: Second Package or Empty
                      Expanded(
                        flex: 280,
                        child: otherPackages.isNotEmpty
                            ? PackageSmallCard(
                                package: otherPackages[0],
                                onTap: () => _handlePackageTap(
                                  context,
                                  otherPackages[0],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      SizedBox(height: 12.h),

                      // Bottom: More Packages Card
                      Expanded(
                        flex: 160,
                        child: PackageMoreCard(
                          onTap: () => _handleViewAllTap(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handlePackageTap(BuildContext context, PackageModel package) {
    NavigationService.pushNamed(RouteName.packageDetail, extra: package.id);
  }

  void _handleEnrollTap(BuildContext context, PackageModel package) {
    NavigationService.pushNamed(RouteName.packageDetail, extra: package.id);
  }

  void _handleViewAllTap(BuildContext context) {
    NavigationService.pushNamed(RouteName.allPackages);
  }
}

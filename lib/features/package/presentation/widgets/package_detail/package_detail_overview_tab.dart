import 'package:durbar_physics/common/widgets/tab_scroll_wrapper_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/package/data/model/package_detail_model.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PackageDetailOverviewTab extends StatelessWidget {
  final PackageDetailModel package;

  const PackageDetailOverviewTab({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return TabScrollWrapperWidget(
      child: CustomScrollView(
        primary: true,
        slivers: [
          SliverOverlapInjector(
            handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
              context,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const TextWidget(
                  word: "Description",
                  size: 18,
                  weight: FontWeight.bold,
                ),
                12.verticalSpace,
                _buildHtmlContent(context, package.description),
                24.verticalSpace,
                80.verticalSpace, // Extra space for bottom bar
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHtmlContent(BuildContext context, String html) {
    return HtmlWidget(
      html,
      textStyle: TextStyle(
        fontSize: 14.sp,
        color: Theme.of(context).textTheme.bodyMedium?.color,
        height: 1.6,
      ),
    );
  }

}

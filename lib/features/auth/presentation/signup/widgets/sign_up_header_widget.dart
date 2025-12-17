import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/common/widgets/title_widget.dart';
import 'package:durbar_physics/core/localization/l10_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpHeaderWidget extends StatelessWidget {
  const SignUpHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        10.verticalSpace,
        TitleWidget(title: l10.signUp),
        TextWidget(
          word: 'Enter your details below and free sign up',

          textColor: Colors.grey[700],
        ),
      ],
    );
  }
}

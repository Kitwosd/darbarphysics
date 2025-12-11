import 'package:dubar_physics/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class SignUpTextfieldWidget extends StatelessWidget {
  final String title;

  const SignUpTextfieldWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TextWidget(
              word: title,
              
              weight: FontWeight.w500,
            ),
            TextWidget(word: '*', textColor: Colors.red),
          ],
        ),
      ],
    );
  }
}

import 'package:dubar_physics/common/widgets/text_widget.dart';
import 'package:dubar_physics/core/localization/bloc/localization_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangeLanguageWidget extends StatelessWidget {
  ChangeLanguageWidget({super.key});

  final ValueNotifier<String> lang = ValueNotifier<String>('');
  final List<String> language = ['Nepali', 'English'];
  final List<String> localeCodes = ['ne', 'en'];

  @override
  Widget build(BuildContext context) {
    lang.value = lang.value.isEmpty
        ? Localizations.localeOf(context).languageCode
        : lang.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(word: 'Change Language'),
        SizedBox(width: 10.w),
        ValueListenableBuilder(
          valueListenable: lang,
          builder: (context, value, child) {
            return DropdownButton<String>(
              value: value,
              items: [
                DropdownMenuItem(
                  value: 'ne',
                  child: TextWidget(word: language[0]),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: TextWidget(word: language[1]),
                ),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  lang.value = newValue;
                  context.read<LocalizationBloc>().add(
                    ChangeLocaleEvent(Locale(newValue)),
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }
}

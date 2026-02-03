import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final String? initialValue;
  final TextInputType inputType;
  final bool enabled;
  final String? errorText;
  final Function(String)? onChanged;

  final double? height;
  final double? width;
  final double? borderWidth;
  final Color? borderColor;
  final String? hintText;
  final bool? obscureIcon;
  final bool obscureText; // NEW PARAMETER
  final double? borderRadius;

  TextFieldWidget({
    super.key,
    required this.label,
    this.initialValue,
    this.inputType = TextInputType.text,
    this.enabled = true,
    this.errorText,
    this.onChanged,
    this.height,
    this.width,
    this.borderWidth,
    this.borderColor,
    this.hintText,
    this.obscureIcon = false,
    this.obscureText = false,
    this.borderRadius, // default false
  });

  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.verticalSpace,
        SizedBox(
          height: height,
          width: width,
          child: obscureText
              ? ValueListenableBuilder<bool>(
                  valueListenable: _obscurePassword,
                  builder: (context, isObscure, _) {
                    return _buildTextField(isObscure, context);
                  },
                )
              : _buildTextField(false, context),
        ),
        8.verticalSpace,
      ],
    );
  }

  TextFormField _buildTextField(bool isObscure, BuildContext context) {
    final Color effectiveBorderColor = borderColor ?? const Color(0xFF828282);
    final double effectiveBorderWidth = borderWidth ?? 1;

    return TextFormField(
      initialValue: initialValue,
      obscureText: isObscure,
      keyboardType: inputType,

      enabled: enabled,
      onChanged: (value) => onChanged?.call(value),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey[500]),

        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0.h),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: effectiveBorderColor,
            width: effectiveBorderWidth,
          ),

          borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: effectiveBorderColor,
            width: effectiveBorderWidth,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: effectiveBorderWidth + 1,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
        ),
        errorText: errorText,
        suffixIcon: obscureText && obscureIcon == true
            ? IconButton(
                onPressed: () {
                  _obscurePassword.value = !isObscure;
                },
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
              )
            : null,
      ),
    );
  }
}

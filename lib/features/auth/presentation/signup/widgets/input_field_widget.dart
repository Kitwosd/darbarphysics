import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final bool obscureText;
  final TextInputType inputType;
  final bool enabled;
  final String? errorText;
  final Function(String)? onChanged;  

  const InputField({
    super.key,
    required this.label,
    this.initialValue,
    this.obscureText = false,
    this.inputType = TextInputType.text,
    this.enabled = true,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.verticalSpace,

        SizedBox(
          child: TextFormField(
            initialValue: initialValue,
            obscureText: obscureText,
            keyboardType: inputType,
            enabled: enabled,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF828282)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF828282)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF828282), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              errorText: errorText,
            ),
          ),
        ),
        8.verticalSpace,
      ],
    );
  }
}

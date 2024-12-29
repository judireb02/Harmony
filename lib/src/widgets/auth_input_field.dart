import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class AuthInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isObscure;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const AuthInputField(
      {super.key,
      required this.label,
      required this.hintText,
      this.isObscure = false,
      this.controller,
      this.validator,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 13.h, bottom: 13.h),
            child: Text(
              label,
              style: AppStyles.subHeading.merge(
                TextStyle(color: AppColors.primaryTextColor.withOpacity(1)),
              ),
            ),
          ),
          TextFormField(
            cursorColor: Theme.of(context).primaryColor,
            controller: controller,
            cursorHeight: 15.sp,
            style: AppStyles.secondaryText.merge(
              const TextStyle(color: AppColors.fieldInputColor),
            ),
            obscureText: isObscure,
            obscuringCharacter: '*',
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.only(left: 15.w),
              constraints: BoxConstraints(
                minWidth: 288.w,
                minHeight: 42.h,
                maxHeight: 42.h,
                maxWidth: 288.w,
              ),
              hintText: hintText,
              fillColor: AppColors.fieldFillColor,
              filled: true,
              hintStyle: AppStyles.secondaryText.merge(
                const TextStyle(color: AppColors.fieldInputColor),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none, // No border when not focused
                borderRadius: BorderRadius.circular(10.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(10.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.fieldFillColor),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            validator: validator,
          )
        ],
      ),
    );
  }
}

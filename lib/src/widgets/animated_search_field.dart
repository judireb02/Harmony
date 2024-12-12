import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmony/src/theme/app_colors.dart';
import 'package:harmony/src/theme/app_styles.dart';

class AnimatedSearchField extends StatefulWidget {
  const AnimatedSearchField({super.key});

  @override
  AnimatedSearchFieldState createState() => AnimatedSearchFieldState();
}

class AnimatedSearchFieldState extends State<AnimatedSearchField> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 356.w,
        child: TextField(
          style: Theme.of(context).primaryTextTheme.labelSmall,
          cursorColor: Theme.of(context).primaryColor,
          controller: _controller,
          decoration: InputDecoration(
            hintStyle: AppStyles.hintTextStyle
                .merge(const TextStyle(color: AppColors.fieldOutlineColor)),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColors.fieldOutlineColor),
                borderRadius: BorderRadius.circular(64.r)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(64.r)),
            hintText: 'Search here...',
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
            prefixIconConstraints: BoxConstraints(
                minWidth: 51.w,
                minHeight: 17.17.h,
                maxHeight: 17.17.h,
                maxWidth: 51.w),
            prefixIcon: Image.asset(
              "assets/images/search_icon.png",
              fit: BoxFit.contain,
            ),
            suffixIconConstraints: BoxConstraints(
                minWidth: 51.w,
                minHeight: 17.17.h,
                maxHeight: 17.17.h,
                maxWidth: 51.w),
            suffixIcon: Image.asset(
              "assets/images/recorder.png",
              fit: BoxFit.contain,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
          onChanged: (value) {},
        ),
      ),
    );
  }
}

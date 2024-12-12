import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class AuthSocialButton extends StatelessWidget {
  final String imagePath;
  final Future<void> Function()? onTap;

  const AuthSocialButton({
    super.key,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null
          ? () async {
              await onTap!();
            }
          : null,
      child: Container(
        width: 86.w,
        height: 42.h,
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            width: imagePath == "assets/images/google.png"
                ? 27.54.w
                : (imagePath == "assets/images/facebook.png" ? 17.w : 31.w),
            height: imagePath == "assets/images/google.png"
                ? 27.54.h
                : (imagePath == "assets/images/facebook.png" ? 26.h : 24.h),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

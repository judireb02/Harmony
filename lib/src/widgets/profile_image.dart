import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileImage extends StatelessWidget {
  final String image;
  final bool hasStatus;
  const ProfileImage({super.key, required this.image, this.hasStatus = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: hasStatus == false
            ? null
            : Border.all(width: 1.5.w, color: Theme.of(context).primaryColor),
      ),
      width: 58.w,
      height: 58.h,
      child: Center(
        child: Image.asset(
          image,
          width: 48.w,
          height: 48.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

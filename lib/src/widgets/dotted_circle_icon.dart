import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class DottedCircleIcon extends StatelessWidget {
  const DottedCircleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final borderColor =
        Theme.of(context).iconTheme.color ?? Colors.black.withOpacity(0.31);
    final iconColor =
        Theme.of(context).iconTheme.color ?? Colors.black.withOpacity(0.31);
    final fillColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.iconFillColor.withOpacity(0.7)
        : AppColors.iconFillColor.withOpacity(0.7);

    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        shape: BoxShape.circle,
      ),
      width: 50.w,
      height: 50.h,
      child: DottedBorder(
        borderType: BorderType.Circle,
        dashPattern: const [8, 4],
        strokeWidth: 2,
        color: borderColor,
        child: Center(
          child: Icon(
            Icons.add,
            color: iconColor,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}

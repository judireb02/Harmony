import 'package:flutter/material.dart';
import 'package:harmony/src/theme/app_styles.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      primaryTextTheme: TextTheme(
        titleMedium: AppStyles.labelTextStyle
            .merge(const TextStyle(color: AppColors.headerTextColor)),
        titleSmall: AppStyles.captionTextStyle
            .merge(const TextStyle(color: AppColors.captionTextColor)),
        labelLarge: AppStyles.subHeading.merge(
          TextStyle(
            color: AppColors.darkBackgroundColor,
          ),
        ),
        labelMedium: AppStyles.subTextStyle
            .merge(const TextStyle(color: AppColors.secondaryTextColor)),
        labelSmall: AppStyles.hintTextStyle
            .merge(const TextStyle(color: AppColors.darkBackgroundColor)),
        displaySmall: AppStyles.tertiaryText
            .merge(const TextStyle(color: AppColors.darkBackgroundColor)),
        titleLarge: AppStyles.heading
            .merge(const TextStyle(color: AppColors.darkBackgroundColor)),
      ),
      iconTheme: IconThemeData(
        color: Colors.black.withOpacity(0.31),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.darkPrimaryColor,
      scaffoldBackgroundColor: AppColors.darkBackgroundColor,
      primaryTextTheme: TextTheme(
        titleMedium: AppStyles.labelTextStyle
            .merge(const TextStyle(color: AppColors.headerTextColorOnDark)),
        titleSmall: AppStyles.captionTextStyle
            .merge(const TextStyle(color: AppColors.captionTextColor)),
        labelLarge: AppStyles.subHeading.merge(
          TextStyle(
            color: AppColors.secondaryTextColorOnDark,
          ),
        ),
        labelMedium: AppStyles.subTextStyle
            .merge(const TextStyle(color: AppColors.secondaryTextColorOnDark)),
        labelSmall: AppStyles.hintTextStyle
            .merge(const TextStyle(color: AppColors.backgroundColor)),
        displaySmall: AppStyles.tertiaryText
            .merge(const TextStyle(color: AppColors.backgroundColor)),
        titleLarge: AppStyles.heading
            .merge(const TextStyle(color: AppColors.backgroundColor)),
      ),
      iconTheme: IconThemeData(
        color: Colors.white.withOpacity(0.6),
      ),
    );
  }
}

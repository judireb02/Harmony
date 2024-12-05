import 'package:flutter/material.dart';
import 'package:harmony/src/theme/app_styles.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        primaryTextTheme: TextTheme(
            displaySmall:
                AppStyles.tertiaryText.merge(TextStyle(color: Colors.black)),
            titleLarge:
                AppStyles.heading.merge(TextStyle(color: Colors.black))));
  }

  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: AppColors.darkPrimaryColor,
        scaffoldBackgroundColor: AppColors.darkBackgroundColor,
        primaryTextTheme: TextTheme(
            displaySmall: AppStyles.tertiaryText
                .merge(TextStyle(color: AppColors.backgroundColor)),
            titleLarge: AppStyles.heading
                .merge(TextStyle(color: AppColors.backgroundColor))));
  }
}

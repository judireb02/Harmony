import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.darkPrimaryColor,
      scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    );
  }
}

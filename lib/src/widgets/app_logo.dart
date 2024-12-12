import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final double width;
  final double height;

  const AppIcon({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/app_logo.png",
      width: width,
      height: height,
    );
  }
}

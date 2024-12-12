import 'package:flutter/material.dart';
import 'package:harmony/src/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) =>  LoginScreen()),
      );
    });
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/splash_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double size = constraints.maxWidth < constraints.maxHeight
                    ? constraints.maxWidth * 0.3
                    : constraints.maxHeight * 0.3;

                return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(size * 0.25),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: FittedBox(
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxWidth,
                      child: Image.asset(
                        "assets/images/H.png",
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/src/screens/camera_screen.dart';
import 'package:harmony/src/screens/chatlist_screen.dart';
import 'package:harmony/src/screens/profile_screen.dart';
import 'package:harmony/src/screens/settings_screen.dart';
import 'package:harmony/src/screens/splash_screen.dart';
import '../../blocs/navigation/navigation_bloc.dart';
import '../../blocs/navigation/navigation_state.dart';
import '../../screens/home_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/signup_screen.dart';

class AppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        switch (state) {
          case NavigationState.login:
            return LoginScreen();
          case NavigationState.signup:
            return SignupScreen();
          case NavigationState.home:
            return HomeScreen();
          case NavigationState.profile:
            return ProfileScreen();
          case NavigationState.chat:
            return ChatlistScreen();
          case NavigationState.camera:
            return CameraScreen();
          case NavigationState.settings:
            return SettingsScreen();
          case NavigationState.splash:
          default:
            return SplashScreen();
        }
      },
    );
  }
}

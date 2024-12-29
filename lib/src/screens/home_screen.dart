import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/custom_bottom_bar.dart';
import 'camera_screen.dart';
import 'chatlist_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _navItems = [
    "assets/images/profile.png",
    "assets/images/chat_icon.png",
    "assets/images/camera.png",
    "assets/images/settings.png"
  ];

  late List<Widget> _screens;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _screens = [
      const ProfileScreen(),
      const ChatlistScreen(),
      const CameraScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        navItems: _navItems,
        initialIndex: _currentIndex,
        onItemTapped: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

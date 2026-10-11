import "package:flutter/material.dart";
import "package:smile_cell/component/bottom_navbar.dart";
import "package:smile_cell/pages/activity_screen.dart";
import "package:smile_cell/pages/home_screen.dart";
import "package:smile_cell/pages/promo_screen.dart";
import "package:smile_cell/pages/profile_screen.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    ActivityScreen(),
    PromoScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
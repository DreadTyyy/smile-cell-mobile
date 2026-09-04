import "package:flutter/material.dart";
import "package:smile_cell/component/bottom_navbar.dart";
import "package:smile_cell/pages/home_screen.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    _EmptyScreen(title: "Aktivitas"),
    _EmptyScreen(title: "Promo"),
    _EmptyScreen(title: "Profil"),
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

class _EmptyScreen extends StatelessWidget {
  final String title;

  const _EmptyScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.0,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "halaman $title belum jadi",
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
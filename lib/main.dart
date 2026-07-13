// TODO: Membuat splashscreen, input no hp screen, input pin screen, input otp screen, input data diri screen

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:smile_cell/pages/home_screen.dart";
import "package:smile_cell/pages/login_screen.dart";
import "package:smile_cell/pages/splash_screen.dart";
import "package:smile_cell/providers/auth_provider.dart";

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const SmileCell(),
    ),
  );
}

class SmileCell extends StatelessWidget {
  const SmileCell({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: "Smile Cell",
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/home": (context) => const HomeScreen(),
        "/login": (context) => const LoginScreen(),
      },
    );
  }
}
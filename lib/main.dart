// TODO: Membuat splashscreen, input no hp screen, input pin screen, input otp screen, input data diri screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smile_cell/pages/home_screen.dart';
import 'package:smile_cell/pages/splash_screen.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(const SmileCell());
}

class SmileCell extends StatelessWidget {
  const SmileCell({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'Smile Cell',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme
        ),
      ),
      initialRoute: "/",
      routes: {
        // "/": (context) => SplashScreen(),
        "/home": (context) => HomeScreen(),
        "/":(context) => SplashScreen()
      }
    );
  }
}

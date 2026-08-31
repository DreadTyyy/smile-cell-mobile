// TODO: Membuat splashscreen, input no hp screen, input pin screen, input otp screen, input data diri screen

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:smile_cell/config/bill_config.dart";
import "package:smile_cell/pages/login_screen.dart";
import "package:smile_cell/pages/bill_screen.dart";
import "package:smile_cell/pages/splash_screen.dart";
import "package:smile_cell/providers/auth_provider.dart";
import "package:smile_cell/pages/main_screen.dart";

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
      scrollBehavior: const GlowScrollBehavior(),
      navigatorObservers: [routeObserver],
      title: "Smile Cell",
      theme: ThemeData(
        fontFamily: GoogleFonts.googleSansFlex().fontFamily,
        textTheme: GoogleFonts.googleSansFlexTextTheme(
          ThemeData.light().textTheme
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF2C93CB),
          primary: Color(0xFF2C93CB),
          surface: Color(0xFFF5F9FC),
          error: Color(0xFFDC2626)
        )
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
        "/home": (context) => const MainScreen(),
        "/login": (context) => const LoginScreen(),
        for (final category in BillCategories.all) 
          '/${category.id}': (context) => BillScreen(category: category)
      },
    );
  }
}

class GlowScrollBehavior extends MaterialScrollBehavior {
  const GlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return GlowingOverscrollIndicator(
      axisDirection: details.direction,
      color: Theme.of(context).colorScheme.primary,
      child: child,
    );
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();
}
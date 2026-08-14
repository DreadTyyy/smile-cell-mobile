import 'package:flutter/material.dart';

Route<T> slideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.ease));
 
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
 
Future<T?> pushSlide<T>(BuildContext context, Widget page) {
  return Navigator.of(context).push<T>(slideRoute<T>(page));
}
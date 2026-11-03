import 'package:flutter/material.dart';

class PinDots extends StatelessWidget {
  const PinDots({
    super.key,
    required this.pinLength,
    required this.filled,
    this.hasError = false,
    this.size = 12,
    this.spacing = 16.0
  });

  final int pinLength;
  final int filled;
  final bool hasError;
  final double size;
  final double spacing;

  static const emptyColor = Color(0xFFBDBDBD);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Semantics(
      label: "$filled dari $pinLength PIN telah dimasukkan",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pinLength, (index) {
          bool isFilled = index < filled;
              
          return Container(
            margin: EdgeInsets.symmetric(horizontal: spacing),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFilled ? primaryColor : emptyColor
            ),
          );
        }),
      ),
    );
  }
}
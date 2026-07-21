import 'package:flutter/material.dart';

class NumericKeypad extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onDeletePressed;

  const NumericKeypad({
    super.key,
    required this.onNumberPressed,
    required this.onDeletePressed
  });

  @override
  Widget build(BuildContext context) {
    final buttons = [
      "1", "2", "3", 
      "4", "5", "6", 
      "7", "8", "9", 
      "", "0", "delete"
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: buttons.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.3
        ), 
        itemBuilder: (context, index) {
          final value = buttons[index];
      
          if (value.isEmpty) {
            return SizedBox();
          }
      
          if (value == "delete") {
            return _KeyboardPad(
              onTap: onDeletePressed,
              child: Icon(
                Icons.backspace_outlined,
                size: 24,
              ),
            );
          }
      
          return _KeyboardPad(
            onTap: () => onNumberPressed(value),
            backgroundColor: Colors.white,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w600,
              ),
            )
          );
        }
      ),
    );
  }
}

class _KeyboardPad extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const _KeyboardPad({
    required this.child,
    required this.onTap,
    this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: 64.0,
      height: 64.0,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: backgroundColor != null ? [BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 4.0,
          spreadRadius: 0.0,
          offset: Offset(0,1)
        )] : null
      ),
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: onTap,
        splashColor: Color(0xFFEAEAEA),
        child: Center(child: child)
      )
    );
  }
}
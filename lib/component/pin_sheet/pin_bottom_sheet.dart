import 'package:flutter/material.dart';
import 'package:smile_cell/component/pin_sheet/pin_dots.dart';
import 'package:smile_cell/widgets/keypad/numeric_keypad.dart';

Future<bool> showPinBottomSheet(BuildContext context) async {
  final sheet = await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))
    ),
    builder: (context) => PinBottomSheet()
  );

  return sheet ?? false;
}

class PinBottomSheet extends StatefulWidget {
  const PinBottomSheet({super.key});

  @override
  State<PinBottomSheet> createState() => _PinBottomSheetState();
}

class _PinBottomSheetState extends State<PinBottomSheet> {
  final pinLength = 6;

  String currentPin = "";
  String errorMessage = "";

  void addNumber(String number) {
    if (currentPin.length >= pinLength) return;

    setState(() {
      if (errorMessage.isNotEmpty) {
        errorMessage = "";
      }

      currentPin += number;
    });

    if (currentPin.length == pinLength) {
      if (currentPin == "123456") {
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          errorMessage = "PIN yang dimasukkan salah";
          currentPin = "";
        });
      }
    }
  }

  void deleteNumber() {
    if (currentPin.isEmpty) return;

    setState(() {
      if (errorMessage.isNotEmpty) {
        errorMessage = "";
      }

      currentPin = currentPin.substring(0, currentPin.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: const Icon(Icons.close_rounded)
                    )
                  ),
                  Text(
                    "Masukkan PIN",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                    )
                  )
                ]
              ),
              SizedBox(height: 16.0),
        
              PinDots(
                pinLength: 6,
                filled: currentPin.length,
                hasError: errorMessage.isNotEmpty,
              ),
        
              SizedBox(
                height: 36.0,
                child: Center(
                  child: Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ),
              ),
        
              NumericKeypad(
                onDeletePressed: deleteNumber,
                onNumberPressed: addNumber,
              ),

              SizedBox(height:24.0)
            ]
          )
        ),
      )
    );
  }
}
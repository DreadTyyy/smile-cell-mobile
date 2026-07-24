import 'package:flutter/material.dart';
import 'package:smile_cell/pages/otp_screen.dart';
import 'package:smile_cell/widgets/keypad/numeric_keypad.dart';

enum PinStep {
  create,
  confirm
}

class PinScreen extends StatefulWidget {
  final String phoneNumber;
  final String fullName;
  final String city;

  const PinScreen({
    super.key,
    required this.phoneNumber,
    required this.fullName,
    required this.city,
  });

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final pinLength = 6;
  PinStep step = PinStep.create;
  
  String currentPin = "";
  String firstPin = "";
  String errorMessage = "";

  void checkPin() {
    if (step == PinStep.create) {
      firstPin = currentPin;

      setState(() {
        currentPin = "";
        step = PinStep.confirm;
      });

      return;
    }

    if (currentPin == firstPin) {
      //TODO: Buat akun baru

      //TODO: arahkan ke otp ketika sukses
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
          pageBuilder: (context, animation, secondaryAnimation) =>
              OtpScreen(phoneNumber: widget.phoneNumber),
        ),
      );
    } else {
      setState(() {
        currentPin = "";
        errorMessage = "PIN tidak sama";
      });
    }
  }

  void addNumber(String number) {
    if (currentPin.length >= pinLength) return;

    setState(() {
      if (errorMessage.isNotEmpty) {
        errorMessage = "";
      }

      currentPin += number;
    });

    if (currentPin.length == pinLength) {
      checkPin();
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

  void _onBackPressed() {
    if (step == PinStep.confirm) {
      setState(() {
        step = PinStep.create;
        firstPin = "";
        currentPin = "";
        errorMessage = "";
      });
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: step == PinStep.create,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (step == PinStep.confirm) {
          setState(() {
            step = PinStep.create;
            currentPin = "";
            firstPin = "";
            errorMessage = "";
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.0,
          foregroundColor: Colors.black,
          leading: IconButton(
            onPressed: _onBackPressed,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
            child: Column(
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ClipRect(
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0), // masuk dari kanan
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    key: ValueKey(step),
                    children: [
                      Text(step == PinStep.create?
                        "Buat PIN":
                        "Masukkan Ulang PIN", 
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(pinLength, (index) {
                          bool filled = index < currentPin.length;
                              
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.0),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: filled ? 
                                Theme.of(context).colorScheme.primary
                                : Color(0xFFBDBDBD)
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 12.0),
                      if (errorMessage.isNotEmpty) 
                        Text("PIN salah. Silahkan masukkan lagi",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).colorScheme.error
                          ),
                        ),
                    ]
                  ),
                ),
          
                Spacer(),
          
                NumericKeypad(
                  onDeletePressed: deleteNumber,
                  onNumberPressed: addNumber,
                ),
          
                SizedBox(height: 64.0)
              ]
            ),
          ),
        ),
      ),
    );
  }
}
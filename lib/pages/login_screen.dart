// TODO: masuk ke laman pin screen dan kirim parameter nomor handphone
// TODO: login -> (failed) -> register | (sucsess) -> homepage [hapus login]

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:smile_cell/pages/register_screen.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _phoneNumberController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  bool get _canNext =>
    _phoneNumberController.text.isNotEmpty &&
    _phoneNumberController.text.length >= 8 &&
    _phoneNumberController.text.length <=12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Masuk dengan Nomor HP",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 16.0),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 6.0,
                ),
                child: Row(
                  children: [
                    const Text(
                      "+62",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(12)
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "123 4567 8900",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 54.0,
                child: ElevatedButton(
                  onPressed: _canNext
                      ? _goToRegister
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C93CB),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 0.0,
                    ),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Lanjutkan",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  void _goToRegister() {
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
            RegisterScreen(phoneNumber: _phoneNumberController.text),
      ),
    );
  }
}
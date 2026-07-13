import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get _otpCode =>
      _controllers.map((controller) => controller.text).join();

  bool get _isOtpValid => _otpCode.length == 6;

  bool get _canResend => _secondsRemaining == 0;

  String get _formattedTime {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return "$minutes:${seconds.toString().padLeft(2, "0")}";
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
      }
      setState(() {
        _secondsRemaining--;
      });
    });
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Masukkan Kode OTP",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8.0),

              Text(
                "Kode verifikasi telah dikirim ke +62 ${widget.phoneNumber}",
                style: const TextStyle(fontSize: 14.0, color: Colors.black54),
              ),

              const SizedBox(height: 24.0),

              Row(
                spacing: 8.0,
                children: List.generate(
                  6,
                  (index) => Expanded(child: _buildOtpBox(index)),
                ),
              ),

              const SizedBox(height: 16.0),

              Center(
                child: _canResend
                    ? TextButton(
                        onPressed: _resendOtp,
                        child: const Text(
                          "Kirim ulang kode",
                          style: TextStyle(
                            color: Color(0xFF2C93CB),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          "Kirim ulang kode dalam $_formattedTime",
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black54,
                          ),
                        ),
                      ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 54.0,
                child: ElevatedButton(
                  onPressed: _isOtpValid ? _verifyOtp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C93CB),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Verifikasi",
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

  Widget _buildOtpBox(int index) {
    return SizedBox(
      height: 56.0,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        autofocus: index == 0,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xFF2C93CB), width: 2.0),
          ),
        ),
        onChanged: (value) => _onDigitChanged(value, index),
      ),
    );
  }

  // TODO: verifikasi _otpCode ke backend, simpan api_token dan user profile
  void _verifyOtp() {
    Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
  }

  // TODO: kirim ulang OTP ke backend
  void _resendOtp() {
    for (final controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
    _startCountdown();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kode OTP telah dikirim ulang")),
    );
  }
}
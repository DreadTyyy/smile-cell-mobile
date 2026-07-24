import "dart:async";

import "package:flutter/material.dart";
import "package:pinput/pinput.dart";

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();

  Timer? _timer;
  Timer? _bannerTimer;
  int _secondsRemaining = 0;
  bool _hasError = false;
  bool _showBanner = false;

  @override
  void initState() {
    super.initState();

    _otpController.addListener(_onOtpChanged);

    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bannerTimer?.cancel();
    _otpController.removeListener(_onOtpChanged);
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onOtpChanged() {
    if (_hasError && _otpController.text.isNotEmpty) {
      setState(() {
        _hasError = false;
      });
      return;
    }

    setState(() {});
  }

  String get _otpCode => _otpController.text;

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

  void _showError() {
    _bannerTimer?.cancel();

    setState(() {
      _hasError = true;
      _showBanner = true;
    });

    _otpController.clear();
    FocusScope.of(context).requestFocus(_focusNode);

    _bannerTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _showBanner = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 52.0,
      height: 56.0,
      textStyle: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.white,
                elevation: 0.0,
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.chevron_left),
                ),
              ),

              Expanded(
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 24.0,
                    ),
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
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 24.0),

                        Center(
                          child: Pinput(
                            length: 6,
                            controller: _otpController,
                            focusNode: _focusNode,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            forceErrorState: _hasError,
                            onCompleted: (pin) =>
                                FocusScope.of(context).unfocus(),
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: defaultPinTheme.copyDecorationWith(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: const Color(0xFF2C93CB),
                                width: 2.0,
                              ),
                            ),
                            errorPinTheme: defaultPinTheme.copyDecorationWith(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: const Color(0xFFDC2626),
                                width: 2.0,
                              ),
                            ),
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                  ),
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
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
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
              ),
            ],
          ),

          if (_showBanner)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8.0,
              left: 16.0,
              right: 16.0,
              child: _buildErrorBanner(),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFDC2626),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20.0),

            const SizedBox(width: 12.0),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gagal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    "Nomor OTP yang dimasukkan salah",
                    style: TextStyle(color: Colors.white, fontSize: 13.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TODO: verifikasi _otpCode ke backend, simpan api_token dan user profile
  void _verifyOtp() {
    // TODO: hapus sebelum push — kode uji sementara
    if (_otpCode != "123456") {
      _showError();
      return;
    }

    Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
  }

  // TODO: kirim ulang OTP ke backend
  void _resendOtp() {
    _otpController.clear();
    _startCountdown();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kode OTP telah dikirim ulang")),
    );
  }
}
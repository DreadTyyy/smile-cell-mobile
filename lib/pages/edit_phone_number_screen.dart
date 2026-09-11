// TODO: LOGIC UPDATE PHONE NUMBER
// TODO: KONEKSI KE OTP SCREEN

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smile_cell/helpers/navigation.dart';
import 'package:smile_cell/pages/otp_screen.dart';

class EditPhoneNumberScreen extends StatefulWidget {
  const EditPhoneNumberScreen({super.key});

  @override
  State<EditPhoneNumberScreen> createState() => _EditPhoneNumberScreenState();
}

class _EditPhoneNumberScreenState extends State<EditPhoneNumberScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.removeListener(() => setState(() {}));
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final fullPhoneNumber = "0${_controller.text}";
    pushSlide(
      context, 
      OtpScreen(
        phoneNumber: fullPhoneNumber,
      )
    );
  }

  bool get _isButtonNotDisabled => 
    _controller.text.isNotEmpty &&
    _controller.text.length >= 8 &&
    _controller.text.length <= 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.0,
        title: Text(
          "Edit Profil",
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Masukkan Nomor Baru",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600
                  )
                ),

                SizedBox(height: 12.0),

                Text(
                  "Silahkan masukkan nomor telepon baru Anda. Pastikan nomor yang dimasukkan aktif dan dapat menerima kode verifikasi.",
                  style: TextStyle(
                    fontSize: 16.0,
                  )
                ),

                SizedBox(height: 24.0),

                TextFormField(
                  controller: _controller,
                  textInputAction: TextInputAction.done,
                  validator: (value) => null,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12)
                  ],
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    hintText: "812 3456 7890",
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "+62",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600
                            )
                          ),
                        ],
                      ),
                    ),
                    errorStyle: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.error,
                      height: 1.2
                    ),
                    errorMaxLines: 2,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 14.0
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: _border(Color(0xFFDDDDDD)),
                    focusedBorder: _border(Theme.of(context).colorScheme.primary),
                    errorBorder: _border(Theme.of(context).colorScheme.error),
                    focusedErrorBorder: _border(Theme.of(context).colorScheme.error),
                    border: _border(Color(0xFFDDDDDD))
                  ),
                ),
                
                const Spacer(),
            
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54.0,
                    child: ElevatedButton(
                      onPressed: _isButtonNotDisabled ? _handleSubmit : null,
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
                        "Lanjut",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      )
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: color, width: 1.0)
  );
}
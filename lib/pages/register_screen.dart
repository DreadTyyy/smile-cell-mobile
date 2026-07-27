// TODO: fungsi menyimpan data ke database (registrasi)
// TODO: masuk ke otp screen
// TODO: login -> (failed) -> register -> (success) -> otp [hapus register]

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:smile_cell/pages/otp_screen.dart";
import "package:smile_cell/pages/pin_screen.dart";

class RegisterScreen extends StatefulWidget {
  final String phoneNumber;

  const RegisterScreen({super.key, required this.phoneNumber});
  

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phoneNumberController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _cityController = TextEditingController();
  final FocusNode _containerFocusNodePhoneNumber = FocusNode();
  final FocusNode _containerFocusNodeName = FocusNode();
  final FocusNode _containerFocusNodeCity = FocusNode();

  String _activeFocus = '';

  @override
  void initState() {
    super.initState();

    _phoneNumberController.text = widget.phoneNumber;

    _phoneNumberController.addListener(() {
      setState(() {});
    });
    _fullNameController.addListener(() {
      setState(() {});
    });
    _cityController.addListener(() {
      setState(() {});
    });

    _containerFocusNodePhoneNumber.addListener(() {
      if (_containerFocusNodePhoneNumber.hasFocus) {
        setState(() => _activeFocus = "phonenumber");
      }
    });

    _containerFocusNodeName.addListener(() {
      if (_containerFocusNodeName.hasFocus) {
        setState(() => _activeFocus = "name");
      }
    });

    _containerFocusNodeCity.addListener(() {
      if (_containerFocusNodeCity.hasFocus) {
        setState(() => _activeFocus = "city");
      }
    });
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _fullNameController.dispose();
    _cityController.dispose();
    _containerFocusNodePhoneNumber.dispose();
    _containerFocusNodeName.dispose();
    _containerFocusNodeCity.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _phoneNumberController.text.isNotEmpty &&
      _phoneNumberController.text.length >= 8 &&
      _phoneNumberController.text.length <=12 &&
      _fullNameController.text.isNotEmpty &&
      _cityController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: const Text(
                  "Daftar & Isi Data Diri",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  const Text(
                    "Nomor Handphone",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Color(0xCC000000),
                    ),
                  ),
                  GestureDetector(
                  onTap: () {
                     _containerFocusNodePhoneNumber.requestFocus();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      border: BoxBorder.all(
                        color:_activeFocus == "phonenumber" ? Color(0xFF2C93CB) : Color(0xFFDDDDDD)
                      ),
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
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_containerFocusNodeName);
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "123 4567 8900",
                              hintStyle: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                                    )
                ],
              ),

              const SizedBox(height: 16.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  const Text(
                    "Nama Lengkap",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Color(0xCC000000),
                    ),
                  ),
                  GestureDetector(
                  onTap: () {
                     _containerFocusNodeName.requestFocus();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _activeFocus == "name" ? Color(0xFF2C93CB) : Color(0xFFDDDDDD))
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 6.0,
                    ),
                    child: TextField(
                      style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                      controller: _fullNameController,
                      focusNode: _containerFocusNodeName,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_containerFocusNodeCity);
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Nama lengkap kamu",
                        hintStyle: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54)
                      ),
                    ),
                  ),
                                    )
                ],
              ),

              const SizedBox(height: 16.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  const Text(
                    "Kota",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Color(0xCC000000),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                     _containerFocusNodeCity.requestFocus();
                  },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: _activeFocus == "city" ? Color(0xFF2C93CB) : Color(0xFFDDDDDD))
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 6.0,
                      ),
                      child: TextField(
                        style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                        controller: _cityController,
                        focusNode: _containerFocusNodeCity,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          _containerFocusNodeCity.unfocus();
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Kota kamu",
                          hintStyle: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54)
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 54.0,
                child: ElevatedButton(
                  onPressed: _isFormValid ? _goToPinScreen : null,
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

  void _goToPinScreen() {
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
            PinScreen(
              phoneNumber: _phoneNumberController.text,
              fullName: _fullNameController.text,
              city: _cityController.text,
            ),
      ),
    );
  }
}
// TODO: koneksi api cek apakah nomor terdaftar
// TODO: ambil data dari be sebagai parameter send_confirm_screen

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:smile_cell/component/bottom_action_bar.dart";
import "package:smile_cell/data/models/send_balance_model.dart";
import "package:smile_cell/helpers/navigation.dart";
import "package:smile_cell/helpers/phone_formatter.dart";
import "package:smile_cell/pages/send_amount_screen.dart";
import "package:smile_cell/services/validation/phone_number_validator.dart";

class SendBalanceScreen extends StatefulWidget {
  const SendBalanceScreen({super.key});

  @override
  State<SendBalanceScreen> createState() => _SendBalanceScreenState();
}

class _SendBalanceScreenState extends State<SendBalanceScreen> {
  final _phoneController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  bool _isFocused = false;
  PhoneValidationError? _validationError = PhoneValidationError.empty;

  @override
  void initState() {
    super.initState();

    _phoneFocusNode.addListener(() {
      setState(() {
        _isFocused = _phoneFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  String get _phoneNumberForDatabase =>
      formatPhoneForDatabase(_phoneController.text);

  bool get _canContinue => _validationError == null;

  String? get _errorText {
    if (_validationError == PhoneValidationError.invalidPrefix) {
      return "Masukkan nomor handphone yang valid";
    }
    return null;
  }

  void _onPhoneChanged() {
    setState(() {
      final phoneNumber = _phoneController.text.startsWith("8")
          ? _phoneNumberForDatabase
          : _phoneController.text;
      _validationError = PhoneNumberValidator.validate(phoneNumber).error;
    });
  }

  void _submit() {
    // TODO: ambil data penerima dari database
    final recipient = Recipient(
      id: _phoneNumberForDatabase,
      name: "Pengguna Smile Cell",
      phoneNumber: _phoneNumberForDatabase,
    );

    FocusScope.of(context).unfocus();
    pushSlide(context, SendAmountScreen(recipient: recipient));
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final error = Theme.of(context).colorScheme.error;
    final errorText = _errorText;
    final borderColor = errorText != null
        ? error
        : _isFocused
            ? primary
            : const Color(0xFFDDDDDD);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Kirim Saldo",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 1.0,
            thickness: 1.0,
            color: Color(0xFFDDDDDD),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Masukkan Nomor Tujuan",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: _phoneFocusNode.requestFocus,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: borderColor, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "+62",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              focusNode: _phoneFocusNode,
                              autofocus: true,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                const PhoneInputFormatter(),
                                LengthLimitingTextInputFormatter(12),
                              ],
                              onChanged: (_) => _onPhoneChanged(),
                              onSubmitted: (_) {
                                if (_canContinue) _submit();
                              },
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                ),
                                hintText: "81234567890",
                                hintStyle: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (errorText != null) ...[
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        errorText,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: error,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          BottomActionBar(
            label: "Lanjut",
            onPressed: _canContinue ? _submit : null,
          ),
        ],
      ),
    );
  }
}
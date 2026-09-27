import "package:flutter/material.dart";
import "package:smile_cell/component/bottom_action_bar.dart";
import "package:smile_cell/config/send_balance_config.dart";
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
  PhoneValidationError? _validationError = PhoneValidationError.empty;
  bool _isNotRegistered = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String get _digits => digitsOnly(_phoneController.text);

  bool get _canContinue => _validationError == null;

  String? get _errorText {
    if (_isNotRegistered) return "Nomor ini belum terdaftar di Smile Cell";
    if (_validationError == PhoneValidationError.invalidPrefix) {
      return "Masukkan nomor handphone yang valid";
    }
    return null;
  }

  void _onPhoneChanged() {
    setState(() {
      _validationError = PhoneNumberValidator.validate(_digits).error;
      _isNotRegistered = false;
    });
  }

  void _submit() {
    final recipient = findRecipient(_digits);

    if (recipient == null) {
      setState(() => _isNotRegistered = true);
      return;
    }

    FocusScope.of(context).unfocus();
    pushSlide(context, SendAmountScreen(recipient: recipient));
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: color, width: 1.0),
  );

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final error = Theme.of(context).colorScheme.error;
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
                  TextField(
                    controller: _phoneController,
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    inputFormatters: const [PhoneInputFormatter()],
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
                      hintText: "0812-3456-7890",
                      hintStyle: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withValues(alpha: 0.4),
                      ),
                      errorText: _errorText,
                      errorStyle: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: error,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      enabledBorder: _border(const Color(0xFFDDDDDD)),
                      focusedBorder: _border(primary),
                      errorBorder: _border(error),
                      focusedErrorBorder: _border(error),
                      border: _border(const Color(0xFFDDDDDD)),
                    ),
                  ),
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
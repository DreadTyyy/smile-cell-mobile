import "package:flutter/services.dart";

String digitsOnly(String text) => text.replaceAll(RegExp(r"[^0-9]"), "");

String formatPhoneNumber(String number, {String separator = "-"}) {
  final digits = digitsOnly(number);
  final buffer = StringBuffer();

  for (int i = 0; i < digits.length; i++) {
    if (i == 4 || i == 8) {
      buffer.write(separator);
    }
    buffer.write(digits[i]);
  }

  return buffer.toString();
}

class PhoneInputFormatter extends TextInputFormatter {
  const PhoneInputFormatter({this.maxDigits = 13});

  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = digitsOnly(newValue.text);

    if (digits.length > maxDigits) {
      return oldValue;
    }

    final formatted = formatPhoneNumber(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
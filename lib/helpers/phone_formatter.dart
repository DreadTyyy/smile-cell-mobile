import "package:flutter/services.dart";

String _digitsOnly(String value) => value.replaceAll(RegExp(r"[^0-9]"), "");

String formatPhoneForDisplay(String value) {
  final digits = _digitsOnly(value);

  if (digits.startsWith("08")) {
    return digits.substring(1);
  }

  if (digits.startsWith("628")) {
    return digits.substring(2);
  }

  return digits;
}

String formatPhoneForDatabase(String value) {
  final displayNumber = formatPhoneForDisplay(value);

  if (displayNumber.isEmpty) {
    return "";
  }

  return "0$displayNumber";
}

class PhoneInputFormatter extends TextInputFormatter {
  const PhoneInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final cursorOffset = newValue.selection.isValid
        ? newValue.selection.extentOffset.clamp(0, text.length)
        : text.length;

    final allDigits = _digitsOnly(text);
    final digitsBeforeCursor = _digitsOnly(text.substring(0, cursorOffset)).length;
    final formatted = formatPhoneForDisplay(text);
    final removedPrefixLength = allDigits.length - formatted.length;
    final newCursorOffset =
        (digitsBeforeCursor - removedPrefixLength).clamp(0, formatted.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorOffset),
    );
  }
}

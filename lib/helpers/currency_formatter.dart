import "package:flutter/services.dart";

String formatThousands(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();

  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(".");
    }
    buffer.write(digits[i]);
  }

  return buffer.toString();
}

String formatRupiah(int value) => "Rp${formatThousands(value)}";

int parseThousands(String text) {
  return int.tryParse(text.replaceAll(".", "")) ?? 0;
}

class ThousandsInputFormatter extends TextInputFormatter {
  const ThousandsInputFormatter({this.maxDigits = 12});

  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r"[^0-9]"), "");

    if (digits.isEmpty) {
      return TextEditingValue.empty;
    }

    if (digits.length > maxDigits) {
      return oldValue;
    }

    final formatted = formatThousands(int.parse(digits));

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
import 'package:intl/intl.dart';

String formatIdr(int value) {
  final formatted = NumberFormat.currency(
    locale: "id_ID",
    symbol: "Rp",
    decimalDigits: 0
  );

  return formatted.format(value);
}
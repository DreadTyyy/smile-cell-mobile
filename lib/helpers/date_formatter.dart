import 'package:intl/intl.dart';

String formatFullDate(DateTime date) {
  return DateFormat("EEEE, dd MMMM yyyy", "id_ID").format(date);
}

String formatTime(DateTime date) {
  return DateFormat("HH:mm", "id_ID").format(date);
}

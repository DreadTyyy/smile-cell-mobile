enum TransactionStatus {
  pending("pending"),
  success("success"),
  failed("failed");

  const TransactionStatus(this.value);

  final String value;
}

class TransactionModel {
  final String id;
  final String billerName;
  final String number;
  final String date;
  final TransactionStatus status;

  const TransactionModel({
    required this.id,
    required this.billerName,
    required this.number,
    required this.date,
    required this.status,
  });

  DateTime get dateTime => DateTime.parse(date);
}
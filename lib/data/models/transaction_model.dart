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
  final int amount;
  final String logoAsset;
  final TransactionStatus status;

  const TransactionModel({
    required this.id,
    required this.billerName,
    required this.number,
    required this.date,
    required this.amount,
    required this.logoAsset,
    required this.status,
  });

  DateTime get dateTime => DateTime.parse(date);

  String get logoPath => "assets/$logoAsset";

  String get formattedAmount {
    final digits = amount.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(".");
      }
      buffer.write(digits[i]);
    }

    return "Rp${buffer.toString()}";
  }
}
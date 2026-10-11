class Recipient {
  final String id;
  final String name;
  final String phoneNumber;

  const Recipient({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });
}

class SendBalanceSummary {
  final Recipient recipient;
  final int amount;
  final int fee;

  const SendBalanceSummary({
    required this.recipient,
    required this.amount,
    this.fee = 0,
  });

  int get total => amount + fee;

  bool get isFree => fee == 0;
}
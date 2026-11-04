import 'package:smile_cell/data/models/detail_bill_model.dart';

enum TransactionStatus {
  pending("pending"),
  success("success"),
  failed("failed");

  const TransactionStatus(this.value);

  final String value;
}

class TransactionModel {
  final String id;
  final BillInquiry bill;
  final DateTime date;
  final TransactionStatus status;

  const TransactionModel({
    required this.id,
    required this.bill,
    required this.date,
    required this.status
  });
}
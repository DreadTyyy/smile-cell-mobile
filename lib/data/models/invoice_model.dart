import 'package:smile_cell/data/models/detail_bill_model.dart';

enum InvoiceType {
  sendBalance,
  topup,
  pln,
  bpjs,
  pdam,
  package,
  phoneCredit
}

class InvoiceModel {
  final BillProduct product;
  final DetailBillModel detail;
  final String transactionId;
  final DateTime dateTime;
  final InvoiceType invoiceType;

  // Optional Data
  final String? customerNumber;
  final String? agentNumber;
  final String? phoneNumber;

  const InvoiceModel({
    required this.product,
    required this.detail,
    required this.transactionId,
    required this.dateTime,
    required this.invoiceType,
    this.customerNumber,
    this.agentNumber,
    this.phoneNumber
  });

  String get customerIdentifier {
    switch (invoiceType) {
      case InvoiceType.sendBalance:
        return agentNumber ?? "";

      case InvoiceType.pln:
      case InvoiceType.bpjs:
      case InvoiceType.pdam:
        return customerNumber ?? "";

      case InvoiceType.package:
      case InvoiceType.phoneCredit:
        return phoneNumber ?? "";
        
      case InvoiceType.topup:
        return "";
    }
  }
}

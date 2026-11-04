// TODO: koneksi api untuk cek pin dan kirim request kirim saldo
// TODO: ambil data response sebagai parameter detail_receipt_screen
// TODO: handle error response dari api kirim saldo

import "package:flutter/material.dart";
import "package:smile_cell/component/pin_sheet/pin_bottom_sheet.dart";
import "package:smile_cell/data/models/detail_bill_model.dart";
import "package:smile_cell/data/models/send_balance_model.dart";
import "package:smile_cell/data/models/transaction_model.dart";
import "package:smile_cell/helpers/navigation.dart";
import "package:smile_cell/pages/detail_bill_screen.dart";
import "package:smile_cell/pages/detail_receipt_screen.dart";

class SendConfirmScreen extends StatelessWidget {
  const SendConfirmScreen({super.key, required this.summary});

  final SendBalanceSummary summary;

  bool _handlePaymentBalance(String pin) {
    if (pin == "123456") {
      return true;
    }
    return false;
  }

  Future<void> _pay(BuildContext context) async {
    final isPaymentSuccess = await showPinBottomSheet(context, _handlePaymentBalance); 
    if (isPaymentSuccess != true) return;

    if (!context.mounted) return;
    pushSlide(
      context, 
      DetailReceiptScreen(
        title: summary.recipient.name,
        subtitle: summary.recipient.phoneNumber,
        data: TransactionModel(
          id: "AJKLAJLAAJLK",
          bill: BillInquiry(
            product: BillProduct(
              name: "Kirim Saldo",
              description: "Kirim saldo ke ${summary.recipient.phoneNumber}",
              imageAsset: "profile_default.png", 
              category: BillType.sendBalance,
            ), 
            details: SendBalanceDetail(
              phoneNumber: summary.recipient.phoneNumber, 
              customerAgent: "192810", 
              customerName: summary.recipient.name,
              amount: summary.amount
            ), 
            payment: PaymentSummary(
              amount: summary.amount,
              fee: summary.fee,
              discount: 0,
            )
          ), 
          date: DateTime.now(), 
          status: TransactionStatus.success
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return DetailBillScreen(
      title: "Kirim Saldo",
      subtitle: summary.recipient.name,
      bill: BillInquiry(
        product: BillProduct(
          name: "Kirim Saldo",
          description: "Kirim saldo ke ${summary.recipient.phoneNumber}",
          imageAsset: "profile_default.png", 
          category: BillType.sendBalance,
        ), 
        details: SendBalanceDetail(
          phoneNumber: summary.recipient.phoneNumber, 
          customerAgent: "192810", 
          customerName: summary.recipient.name,
          amount: summary.amount
        ), 
        payment: PaymentSummary(
          amount: summary.amount,
          fee: summary.fee,
          discount: 0,
        )
      ),
      onPay: (context) => _pay(context),
    );
  }
}

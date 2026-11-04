// TODO: koneksi api untuk cek pin dan kirim request kirim saldo
// TODO: ambil data response sebagai parameter detail_receipt_screen
// TODO: handle error response dari api kirim saldo

import "package:flutter/material.dart";
import "package:smile_cell/component/pin_sheet/pin_bottom_sheet.dart";
import "package:smile_cell/data/models/detail_bill_model.dart";
import "package:smile_cell/data/models/invoice_model.dart";
import "package:smile_cell/data/models/send_balance_model.dart";
import "package:smile_cell/helpers/currency_formatter.dart";
import "package:smile_cell/helpers/navigation.dart";
import "package:smile_cell/helpers/phone_formatter.dart";
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
        data: InvoiceModel(
          product: BillProduct(
            name: summary.recipient.phoneNumber,
            description: summary.recipient.name,
            imageAsset: "profile_default.png",
          ), 
          detail: DetailBillModel(
            information: [],
            price: summary.amount.toDouble(),
            fee: summary.fee.toDouble(),
            discount: 0,
          ), 
          transactionId: "AJKLAJLAAJLK", 
          dateTime: DateTime.now(), 
          invoiceType: InvoiceType.sendBalance
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return DetailBillScreen(
      product: BillProduct(
        name: "Kirim Saldo",
        description: summary.recipient.name,
        imageAsset: "profile_default.png",
      ),
      detail: DetailBillModel(
        information: [
          BillInformation(
            key: "Nomor Handphone",
            value: formatPhoneNumber(
              summary.recipient.phoneNumber,
              separator: " ",
            ),
          ),
          BillInformation(
            key: "Nominal Kirim",
            value: formatRupiah(summary.amount),
          ),
        ],
        price: summary.amount.toDouble(),
        fee: summary.fee.toDouble(),
        discount: 0,
      ),
      onPay: (context) => _pay(context),
    );
  }
}

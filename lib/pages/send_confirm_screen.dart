import "package:flutter/material.dart";
import "package:smile_cell/data/models/detail_bill_model.dart";
import "package:smile_cell/data/models/send_balance_model.dart";
import "package:smile_cell/helpers/currency_formatter.dart";
import "package:smile_cell/helpers/phone_formatter.dart";
import "package:smile_cell/pages/detail_bill_screen.dart";

class SendConfirmScreen extends StatelessWidget {
  const SendConfirmScreen({super.key, required this.summary});

  final SendBalanceSummary summary;

  void _pay(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);

    Navigator.of(context).popUntil((route) => route.isFirst);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          "Saldo ${formatRupiah(summary.total)} berhasil dikirim "
          "ke ${summary.recipient.name}",
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DetailBillScreen(
      product: BillProduct(
        name: "Kirim Saldo",
        description: summary.recipient.name,
        imageAsset: "Vector.png",
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
      onPay: () => _pay(context),
    );
  }
}

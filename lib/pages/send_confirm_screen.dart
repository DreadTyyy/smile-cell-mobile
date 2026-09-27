import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:smile_cell/component/bottom_action_bar.dart";
import "package:smile_cell/data/models/send_balance_model.dart";
import "package:smile_cell/helpers/currency_formatter.dart";
import "package:smile_cell/helpers/phone_formatter.dart";
import "package:smile_cell/providers/balance_provider.dart";

class SendConfirmScreen extends StatelessWidget {
  const SendConfirmScreen({super.key, required this.summary});

  final SendBalanceSummary summary;

  void _pay(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    final isSent = context.read<BalanceProvider>().send(summary.total);

    if (!isSent) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text("Saldo kamu tidak mencukupi"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Kirim Saldo",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 1.0,
            thickness: 1.0,
            color: Color(0xFFDDDDDD),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  height: 160.0,
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildSummaryCard(context),
                ),
              ],
            ),
          ),
          BottomActionBar(
            label: "Bayar",
            onPressed: () => _pay(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 12.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Color(0xFF8A8A8A),
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 26.0,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Kirim Saldo",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          summary.recipient.name,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Nomor Handphone"),
                  const SizedBox(height: 4.0),
                  Text(
                    formatPhoneNumber(
                      summary.recipient.phoneNumber,
                      separator: " ",
                    ),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildLabel("Nominal Kirim"),
                  const SizedBox(height: 4.0),
                  Text(
                    formatRupiah(summary.amount),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const _DashedDivider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildDetailRow("Nominal", formatRupiah(summary.amount)),
                  const SizedBox(height: 12.0),
                  _buildDetailRow(
                    "Layanan",
                    summary.isFree ? "Gratis" : formatRupiah(summary.fee),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Tagihan",
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                      ),
                      Text(
                        formatRupiah(summary.total),
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.0,
        color: Colors.black.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15.0, color: Colors.black),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15.0, color: Colors.black),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  static const _dashWidth = 6.0;
  static const _gapWidth = 4.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count =
            (constraints.maxWidth / (_dashWidth + _gapWidth)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < count; i++)
              Container(
                width: _dashWidth,
                height: 1.0,
                color: const Color(0xFFCCCCCC),
              ),
          ],
        );
      },
    );
  }
}
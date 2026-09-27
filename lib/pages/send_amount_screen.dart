import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:smile_cell/component/bottom_action_bar.dart";
import "package:smile_cell/config/send_balance_config.dart";
import "package:smile_cell/data/models/send_balance_model.dart";
import "package:smile_cell/helpers/currency_formatter.dart";
import "package:smile_cell/helpers/navigation.dart";
import "package:smile_cell/helpers/phone_formatter.dart";
import "package:smile_cell/pages/send_confirm_screen.dart";
import "package:smile_cell/providers/balance_provider.dart";

class SendAmountScreen extends StatefulWidget {
  const SendAmountScreen({super.key, required this.recipient});

  final Recipient recipient;

  @override
  State<SendAmountScreen> createState() => _SendAmountScreenState();
}

class _SendAmountScreenState extends State<SendAmountScreen> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int get _amount => parseThousands(_amountController.text);

  int get _balance => context.read<BalanceProvider>().balance;

  bool get _exceedsBalance => _amount > _balance;

  bool get _isValid =>
      _amount >= minSendAmount &&
      _amount <= maxSendAmount &&
      !_exceedsBalance;

  bool get _showError => _amountController.text.isNotEmpty && !_isValid;

  String get _hintText {
    if (_exceedsBalance) return "Saldo kamu tidak mencukupi";
    if (_amount > maxSendAmount) {
      return "Maksimal kirim ${formatRupiah(maxSendAmount)}";
    }
    return "Minimal kirim ${formatRupiah(minSendAmount)}";
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    pushSlide(
      context,
      SendConfirmScreen(
        summary: SendBalanceSummary(
          recipient: widget.recipient,
          amount: _amount,
          fee: sendBalanceFee,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final balance = context.watch<BalanceProvider>().balance;
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildRecipientCard(balance),
                  const SizedBox(height: 20.0),
                  _buildAmountSection(),
                ],
              ),
            ),
          ),
          BottomActionBar(
            label: "Lanjut",
            onPressed: _isValid ? _submit : null,
          ),
        ],
      ),
    );
  }

  Widget _buildRecipientCard(int balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 12.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Kirim Ke:",
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.black.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
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
                    Text(
                      widget.recipient.name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      formatPhoneNumber(widget.recipient.phoneNumber),
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const Divider(height: 1.0, thickness: 1.0, color: Color(0xFFDDDDDD)),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Saldo SmileCell",
                style: TextStyle(fontSize: 14.0, color: Colors.black),
              ),
              Text(
                formatRupiah(balance),
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    final error = Theme.of(context).colorScheme.error;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "JUMLAH KIRIM",
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12.0),
          Container(
            padding: const EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: _showError ? error : const Color(0xFFDDDDDD),
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  "Rp",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: const [
                      ThousandsInputFormatter(maxDigits: 9),
                    ],
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) {
                      if (_isValid) _submit();
                    },
                    style: const TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: "0",
                      hintStyle: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            _hintText,
            style: TextStyle(
              fontSize: 12.0,
              color: _showError ? error : Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
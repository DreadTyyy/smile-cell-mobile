import "package:flutter/material.dart";
import "package:smile_cell/config/top_up_config.dart";
import "package:smile_cell/data/models/payment_model.dart";
import "package:smile_cell/helpers/currency_formatter.dart";
import "package:smile_cell/helpers/navigation.dart";
import "package:smile_cell/pages/transfer_screen.dart";

class TopUpScreen extends StatelessWidget {
  const TopUpScreen({super.key});

  Future<void> _onMethodSelected(
    BuildContext context,
    PaymentMethod method,
  ) async {
    final amount = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (_) => _AmountSheet(method: method),
    );
    if (amount == null || !context.mounted) return;
    pushSlide(context, TransferScreen(method: method, amount: amount));
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
          "Isi Saldo",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.chevron_left),
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _MethodSection(
            title: "BANK YANG DIDUKUNG",
            methods: supportedBanks,
            onTap: (method) => _onMethodSelected(context, method),
          ),
        ],
      ),
    );
  }
}

class _MethodSection extends StatelessWidget {
  const _MethodSection({
    required this.title,
    required this.methods,
    required this.onTap,
  });

  final String title;
  final List<PaymentMethod> methods;
  final void Function(PaymentMethod method) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 12.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                  color: Colors.black.withValues(alpha: 0.6),
                ),
              ),
            ),
            for (int i = 0; i < methods.length; i++) ...[
              _MethodTile(
                method: methods[i],
                onTap: () => onTap(methods[i]),
              ),
              if (i < methods.length - 1)
                const Divider(
                  height: 1.0,
                  thickness: 1.0,
                  indent: 16.0,
                  endIndent: 16.0,
                  color: Color(0xFFDDDDDD),
                ),
            ],
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({required this.method, required this.onTap});

  final PaymentMethod method;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Image.asset(
              method.logoPath,
              width: 48.0,
              height: 24.0,
              fit: BoxFit.contain,
              semanticLabel: "Logo ${method.name}",
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                method.name,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountSheet extends StatefulWidget {
  const _AmountSheet({required this.method});

  final PaymentMethod method;

  @override
  State<_AmountSheet> createState() => _AmountSheetState();
}

class _AmountSheetState extends State<_AmountSheet> {
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged() => setState(() {});

  int get _amount => parseThousands(_amountController.text);

  bool get _isValid =>
      _amount >= minTopUpAmount && _amount <= maxTopUpAmount;

  bool get _showError => _amountController.text.isNotEmpty && !_isValid;

  String get _hintText => _amount > maxTopUpAmount
      ? "Maksimal isi saldo ${formatRupiah(maxTopUpAmount)}"
      : "Minimal isi saldo ${formatRupiah(minTopUpAmount)}";

  void _submit() => Navigator.of(context).pop(_amount);

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: color, width: 1.0),
  );

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final error = Theme.of(context).colorScheme.error;
    final borderColor = _showError ? error : primary;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Masukkan Jumlah Transfer",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _amountController,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: const [ThousandsInputFormatter(maxDigits: 9)],
                onSubmitted: (_) {
                  if (_isValid) _submit();
                },
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: "0",
                  hintStyle: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withValues(alpha: 0.2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                    child: Text(
                      "Rp",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0.0,
                    minHeight: 0.0,
                  ),
                  enabledBorder: _border(borderColor),
                  focusedBorder: _border(borderColor),
                  border: _border(borderColor),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                _hintText,
                style: TextStyle(
                  fontSize: 12.0,
                  color: _showError
                      ? error
                      : Colors.black.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 16.0),
              Text.rich(
                TextSpan(
                  text: "Metode isi saldo: ",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black.withValues(alpha: 0.8),
                  ),
                  children: [
                    TextSpan(
                      text: widget.method.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 54.0,
                child: ElevatedButton(
                  onPressed: _isValid ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Lanjut",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import "dart:async";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:smile_cell/config/top_up_config.dart";
import "package:smile_cell/config/transaction_config.dart";
import "package:smile_cell/data/models/payment_model.dart";
import "package:smile_cell/helpers/currency_formatter.dart";

class TransferScreen extends StatefulWidget {
  const TransferScreen({
    super.key,
    required this.method,
    required this.amount,
  });

  final PaymentMethod method;
  final int amount;

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  late final DateTime _deadline;
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _deadline = DateTime.now().add(transferTimeLimit);
    _remaining = _deadline.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    final remaining = _deadline.difference(DateTime.now());

    if (remaining <= Duration.zero) {
      _timer?.cancel();
      setState(() => _remaining = Duration.zero);
      return;
    }

    setState(() => _remaining = remaining);
  }

  bool get _isExpired => _remaining == Duration.zero;

  String get _formattedRemaining {
    final hours = _remaining.inHours.toString().padLeft(2, "0");
    final minutes = (_remaining.inMinutes % 60).toString().padLeft(2, "0");
    final seconds = (_remaining.inSeconds % 60).toString().padLeft(2, "0");

    return "$hours:$minutes:$seconds";
  }

  String get _deadlineText {
    if (_isExpired) return "Waktu pembayaran telah habis.";

    final hour = _deadline.hour.toString().padLeft(2, "0");
    final minute = _deadline.minute.toString().padLeft(2, "0");

    return "Selesaikan sebelum ${formatTransactionDate(_deadline)} "
        "$hour:$minute WIB.";
  }

  void _backToHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _backToHome();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
          elevation: 0.0,
          foregroundColor: Colors.black,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Transfer Sekarang",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
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
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        _deadlineText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.black.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      _buildCountdown(),
                      const SizedBox(height: 20.0),
                      _buildTransferCard(),
                    ],
                  ),
                ),
              ),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountdown() {
    final error = Theme.of(context).colorScheme.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: error.withValues(alpha: 0.08),
        border: Border.all(color: error.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        _formattedRemaining,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: error,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }

  Widget _buildTransferCard() {
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
          _buildLabel("Rekening Tujuan:"),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Image.asset(
                widget.method.logoPath,
                width: 48.0,
                height: 24.0,
                fit: BoxFit.contain,
                semanticLabel: "Logo ${widget.method.name}",
              ),
              const SizedBox(width: 12.0),
              Text(
                widget.method.transferLabel,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          _CopyField(
            value: widget.method.accountNumber,
            copyText: widget.method.accountNumber,
            copiedMessage: "Nomor rekening disalin",
          ),
          const SizedBox(height: 16.0),
          const Divider(height: 1.0, thickness: 1.0, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16.0),
          _buildLabel("Nominal Transfer:"),
          const SizedBox(height: 8.0),
          _CopyField(
            value: formatRupiah(widget.amount),
            copyText: widget.amount.toString(),
            copiedMessage: "Nominal transfer disalin",
          ),
          const SizedBox(height: 12.0),
          const _NoticeBox(
            message: "Pastikan nomor rekening dan nominal transfer sudah "
                "sesuai agar transaksi Anda dapat diproses.",
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.0,
        color: Colors.black.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _buildActions() {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
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
              borderRadius: BorderRadius.circular(8.0),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox(
                  height: 48.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.support_agent_rounded,
                        color: primary,
                        size: 20.0,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        "Hubungi Smile Cell",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          SizedBox(
            width: double.infinity,
            height: 54.0,
            child: ElevatedButton(
              onPressed: _backToHome,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Selesai",
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
    );
  }
}

class _CopyField extends StatelessWidget {
  const _CopyField({
    required this.value,
    required this.copyText,
    required this.copiedMessage,
  });

  final String value;
  final String copyText;
  final String copiedMessage;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: copyText));
    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(copiedMessage),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      height: 52.0,
      padding: const EdgeInsets.only(left: 16.0, right: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDDDDDD)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _copy(context),
            style: TextButton.styleFrom(
              foregroundColor: primary,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              minimumSize: const Size(48.0, 40.0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              "Salin",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationColor: primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeBox extends StatelessWidget {
  const _NoticeBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        color: primary.withValues(alpha: 0.6),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: Icon(
                Icons.info_outline_rounded,
                size: 16.0,
                color: primary,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 12.0,
                  height: 1.4,
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color});

  final Color color;

  static const _radius = 8.0;
  static const _dashLength = 5.0;
  static const _gapLength = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final outline = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(0.5),
          const Radius.circular(_radius),
        ),
      );
    for (final metric in outline.computeMetrics()) {
      double distance = 0.0;

      while (distance < metric.length) {
        final end = distance + _dashLength < metric.length
            ? distance + _dashLength
            : metric.length;
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + _gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
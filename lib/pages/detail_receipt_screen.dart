import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smile_cell/component/receipt_page.dart';
import 'package:smile_cell/data/models/detail_bill_model.dart';
import 'package:smile_cell/data/models/transaction_model.dart';
import 'package:smile_cell/helpers/date_formatter.dart';
import 'package:smile_cell/helpers/format_currency.dart';

class DetailReceiptScreen extends StatefulWidget {
  const DetailReceiptScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.data
  });

  final String title;
  final String subtitle;
  final TransactionModel data;

  @override
  State<DetailReceiptScreen> createState() => _DetailReceiptScreenState();
}

class _DetailReceiptScreenState extends State<DetailReceiptScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;

  Future<void> _shareReceipt() async {
    if (_isSharing) return;

    setState(() => _isSharing = true);

    try {
      BillDetail billDetail = widget.data.bill.details;

      final imageBytes = await _screenshotController.captureFromLongWidget(
        InheritedTheme.captureAll(
          context,
            Material(
            color: Colors.white,
            child: ReceiptPage(
              title: widget.title,
              subtitle: widget.subtitle,
              subsubtitle: billDetail is SendBalanceDetail ? billDetail.customerAgent : billDetail.targetNumber,
              data: widget.data
            )
          )
        ),
        context: context,
        pixelRatio: 3,
        delay: Duration(milliseconds: 500)
      );

      final directory = await getTemporaryDirectory();
      final file = File("${directory.path}/invoice_${widget.data.id}.png");
      await file.writeAsBytes(imageBytes, flush: true);

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(file.path, mimeType: "image/png")
          ],
          text: "Bukti transaksi"
        )
      );
    } catch (e) {
      debugPrint("Gagal membagikan struk: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal membagikan struk. Coba lagi.")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailPrices = [
      {
        "key": "Harga",
        "value": formatIdr(widget.data.bill.payment.amount)
      },
      {
        "key": "Biaya Admin",
        "value": widget.data.bill.payment.fee == 0 ? "Gratis" : formatIdr(widget.data.bill.payment.fee)
      },
      {
        "key": "Diskon",
        "value": widget.data.bill.payment.discount == 0 ? 0 : formatIdr(widget.data.bill.payment.discount)
      },
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          // surfaceTintColor: Colors.transparent,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.0,
          foregroundColor: Colors.black,
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
          title: Text(
            "Rincian Transaksi",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600
            )
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            icon: Icon(Icons.arrow_back_rounded),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(height: 1.0, thickness:1.0, color: Color(0xFFDDDDDD))
          )
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  // HEADER
                  widget.data.status == TransactionStatus.success ? 
                  Image.asset(
                    "assets/splash_success.png",
                    width: 180.0
                  ) : SizedBox.shrink(),
                  SizedBox(height: 20.0),
                  Text(
                    "Transaksi ${widget.data.status == TransactionStatus.success ? "Berhasil" : widget.data.status == TransactionStatus.pending ? "Sedang Diproses" : "Gagal"}",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600
                    )
                  ),
                  SizedBox(height: 6.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4.0,
                    children: [
                      Text(
                        formatFullDate(widget.data.date),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withValues(alpha: 0.7)
                        )
                      ),
                      Text(
                        formatTime(widget.data.date),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withValues(alpha: 0.7)
                        )
                      ),
                    ]
                  ),
            
                  // DETAILS 
                  SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0)
                        ),
                        color: Colors.white,
                        boxShadow: _cardShadow
                      ),
                      child: Column(
                        spacing: 16.0,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  spacing: 8.0,
                                  children: [
                                    Container(
                                      width: 44.0,
                                      height: 44.0,
                                      // Padding untuk kirim saldo dihilangkan karena gambar sudah berbentuk lingkaran
                                      padding: widget.data.bill.product.category != BillType.sendBalance ? 
                                        EdgeInsets.all(8.0) : EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF2F8FD),
                                        shape: BoxShape.circle
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/${widget.data.bill.product.imageAsset}",
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.contain
                                        )
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.title,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              height: 1.2
                                            )
                                          ),
                                          Text(
                                            widget.subtitle,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF727272)
                                            )
                                          )
                                        ]
                                      ),
                                    )
                                  ]
                                ),
                              ),
                              widget.data.status == TransactionStatus.success ?
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFF00C853).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(999.0)
                                ),
                                child: Text(
                                  "Berhasil",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF00C853)
                                  )
                                )
                              ) : SizedBox.shrink()
                            ],
                          ),

                          // Kirim saldo tidak perlu tampilan detail tagihan
                          widget.data.bill.product.category != BillType.sendBalance ?
                          Column(
                            spacing: 8.0,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _TitleListDetail(title: "DETAIL TAGIHAN"),
                              ...widget.data.bill.details.informations.map((info) {
                                return _DetailInformation(
                                  title: info.key,
                                  value: info.value
                                );
                              })
                            ],
                          ) : SizedBox.shrink(),
      
                          Column(
                            spacing: 8.0,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _TitleListDetail(title: "DETAIL PEMBAYARAN"),
                              _DetailInformation(title: "No Referensi", value: widget.data.id),
                              ...detailPrices.map((item) {
                                if (item['key'] == "Diskon" && item['value'] == 0) return SizedBox();
                    
                                return _DetailInformation(
                                  title: "${item['key']}",
                                  value: item['key'] == "Diskon" ? "-${item['value']}" : "${item['value']}"
                                );
                              }),
                            ],
                          )
                        ]
                      )
                    ),
                  ),
            
                  // PRICE
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFF2F8FD),
                        boxShadow: _cardShadow
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Bayar",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black
                            )
                          ),
                          Text(
                            formatIdr(widget.data.bill.payment.totalAmount),
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary
                            )
                          ),
                        ]
                      )
                    ),
                  ),
            
                  // FOOTER
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
                    child: Column(
                      spacing: 16.0,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            "assets/icon-contact-support.svg",
                            width: 24.0,
                            height: 24.0,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.primary,
                              BlendMode.srcIn
                            )
                          ),
                          label: Text(
                            "Hubungi SmileCell",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500
                            )
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                            )
                          )
                        ),

                        widget.data.status == TransactionStatus.success ?
                        ElevatedButton.icon(
                          onPressed: widget.data.status == TransactionStatus.success && _isSharing ? null : _shareReceipt,
                          icon: _isSharing
                          ? const SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.white),
                            )
                          : Icon(
                            Icons.share_rounded,
                            size: 24.0,
                            color: Colors.white
                          ),
                          label: Text(
                            "Bagikan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600
                            )
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                            )
                          )
                        ) : SizedBox.shrink()
                      ]
                    ),
                  )
                ]
              ),
            ),
          )
        )
      ),
    );
  }

  static const List<BoxShadow> _cardShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      blurRadius: 4.0,
      offset: Offset(0, 1),
    ),
  ];
}

class _TitleListDetail extends StatelessWidget {
  const _TitleListDetail({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
        color: Colors.black
      ),
    );
  }
}

class _DetailInformation extends StatelessWidget {
  const _DetailInformation({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF727272)
          )
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: Colors.black
          )
        )
      ]
    );
  }
}
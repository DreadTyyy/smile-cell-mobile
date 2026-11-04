import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:smile_cell/data/models/detail_bill_model.dart';
import 'package:smile_cell/helpers/format_currency.dart';

class DetailBillScreen extends StatefulWidget {
  const DetailBillScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.bill,
    required this.onPay,
  });

  final String title;
  final String subtitle;
  final BillInquiry bill;
  final Function(BuildContext context) onPay;

  @override
  State<DetailBillScreen> createState() => _DetailBillScreenState();
}

class _DetailBillScreenState extends State<DetailBillScreen> {
  @override
  Widget build(BuildContext context) {
    final detailPrices = [
      {
        "key": "Nominal",
        "value": formatIdr(widget.bill.payment.amount)
      },
      {
        "key": "Biaya Admin",
        "value": widget.bill.payment.fee == 0 ? "Gratis" : formatIdr(widget.bill.payment.fee)
      },
      {
        "key": "Diskon",
        "value": widget.bill.payment.discount == 0 ? 0 : formatIdr(widget.bill.payment.discount)
      },
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "Detail Tagihan",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(), 
          icon: Icon(Icons.arrow_back_rounded)
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), 
          child: Divider(height: 1.0, thickness: 1.0, color: Color(0xFFDDDDDD)) 
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 240.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ),
              
                  // === DETAIL BILL ===
                  Positioned(
                    top: 24.0,
                    left: 16.0,
                    right: 16.0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: BoxBorder.all(width: 1.0, color: Color(0xFFDDDDDD)),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          
                          Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Color(0xFFF2F8FD),
                            ),
                            child: Row(
                              spacing: 8.0,
                              children: [
                                SizedBox(
                                  width: 32.0,
                                  height: 32.0,
                                  child: Image.asset(
                                    widget.bill.product.imagePath,
                                    fit: BoxFit.contain,
                                    height: 32.0,
                                    width: 32.0,
                                  )
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    Text(
                                      widget.subtitle,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black.withValues(alpha: 0.6)
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                    
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10.0,
                              children: widget.bill.details.informations.map((item) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.key,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black.withValues(alpha: 0.6)
                                      ),
                                    ),
                                    Text(
                                      item.value,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600
                                      )
                                    )
                                  ],
                                );
                              }).toList() 
                            ),
                          ),

                          DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 1,
                            dashLength: 6,
                            dashGapLength: 4,
                            dashColor: Color(0xFFDDDDDD),
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 4.0,
                              children: [
                                ...detailPrices.map((item) {
                                  if (item['key'] == "Diskon" && item['value'] == 0) return SizedBox();
                      
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${item['key']}",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      Text(
                                        item['key'] == "Diskon" ? "-${item['value']}" : "${item['value']}",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        )
                                      )
                                    ],
                                  );
                                }),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Tagihan",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    Text(
                                      formatIdr(widget.bill.payment.totalAmount),
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).colorScheme.primary
                                      )
                                    )
                                  ],
                                ),
                              ]
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 54.0,
                child: ElevatedButton(
                  onPressed: () => widget.onPay(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 0.0,
                    ),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Bayar",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          
            const SizedBox(height: 24.0),
          ],
        )
      ),
    );
  }
}
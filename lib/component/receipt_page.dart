import "dart:ui" as ui;

import "package:dotted_line/dotted_line.dart";
import "package:flutter/material.dart";
import "package:smile_cell/component/invoice_watermark.dart";
import "package:smile_cell/data/models/invoice_model.dart";
import "package:smile_cell/helpers/date_formatter.dart";
import "package:smile_cell/helpers/formatCurrency.dart";

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({
    super.key,
    required this.data
  });

  final InvoiceModel data;

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  ui.Image? _logo;

  @override
  void initState() {
    super.initState();
    loadUiImage("assets/watermark.png").then((img) {
      if (mounted) setState(() => _logo = img);
    });
  }

  @override
  void dispose() {
    _logo?.dispose();
    super.dispose();
  }  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.0,
      padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        children: [
          // LOGO
          Container(
            padding: EdgeInsets.only(top: 28.0, bottom: 16.0),
            child: Image.asset(
              "assets/Vector.png",
              width: 52.0,
              height: 52.0,
              fit: BoxFit.cover
            )
          ),
      
          // CARD
          WatermarkedBox(
            logo: _logo,
            text: "SmileCell",
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
              child: Column(
                children: [
                  // HEADER
                  Row(
                    spacing: 16.0,
                    children: [
                      Container(
                        width: 48.0,
                        height: 48.0,
                        padding: widget.data.detail.information.isNotEmpty ? 
                          EdgeInsets.all(8.0) : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Color(0xFFF2F8FD),
                          shape: BoxShape.circle
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/${widget.data.product.imageAsset}",
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data.product.description,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            )
                          ),
                          Row(
                            spacing: 4.0,
                            children: [
                              Text(
                                widget.data.product.name,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF727272)
                                )
                              ),
                              Text(
                                widget.data.customerIdentifier,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF727272)
                                )
                              ),
                            ]
                          ),
                        ]
                      )
                    ]
                  ),
                  SizedBox(height: 24.0),
                            
                  DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 1,
                    dashLength: 6,
                    dashGapLength: 4,
                    dashColor: Colors.black,
                  ),
                  
                  // CONTENT
                  SizedBox(height: 16.0),
                  Text(
                    formatIdr(widget.data.detail.price + widget.data.detail.fee - widget.data.detail.discount),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary
                    ),
                    textAlign: TextAlign.center
                  ),
                  SizedBox(height: 16.0),
                            
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailInformation(title: "No Referensi", value: widget.data.transactionId),
                      _DetailInformation(title: "Tanggal", value: formatFullDate(widget.data.dateTime)),
                      _DetailInformation(title: "Waktu", value: formatTime(widget.data.dateTime)),
                    ]
                  ),
                  SizedBox(height: 16.0),
      
                  widget.data.detail.information.isNotEmpty ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TitleListDetail(title: "DETAIL TAGIHAN"),
                      ...widget.data.detail.information.map((info) {
                        return _DetailInformation(
                          title: info.key,
                          value: info.value
                        );
                      })
                    ],
                  ) : SizedBox.shrink(),
                  SizedBox(height: 16.0),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TitleListDetail(title: "SUMBER DANA"),
                      _DetailInformation(title: "No Agent", value: "19252"),
                      _DetailInformation(title: "Nama", value: "Zaky Haidar"),
                    ]
                  ),
                ]
              ),
            )
          ),

          // FOOTER
          SizedBox(height: 24.0),
          Text(
            "Resi ini merupakan bukti pembayaran yang sah.",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF727272)
            ),
            textAlign: TextAlign.center
          )
        ],
      )
    );
  }
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
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFDDDDDD),
            width: 1.0
          )
        )
      ),
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
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
      ),
    );
  }
}
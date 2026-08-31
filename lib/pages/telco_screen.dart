// TODO: Pengambilan data dari server

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smile_cell/component/tab_bar_section.dart';
import 'package:smile_cell/data/models/telco_model.dart';
import 'package:smile_cell/services/phone_provider_detector.dart';
import 'package:smile_cell/services/validation/phone_number_validator.dart';

class TelcoScreen extends StatefulWidget {
  const TelcoScreen({
    super.key,
  });


  @override
  State<TelcoScreen> createState() => _TelcoScreenState();
}

class _TelcoScreenState extends State<TelcoScreen> 
  with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _phoneNumberController = TextEditingController();
  String _phoneNumber = "";
  ProviderModel? _provider;
  PhoneValidationError? _phoneValidationError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onPhoneNumberChanged(String value) {
    final validationResult = PhoneNumberValidator.validate(value);
    setState(() {
      _phoneNumber = value;
      _phoneValidationError = validationResult.error;
      _provider = PhoneProviderDetector.detect(_phoneNumber);
    });
  }

  void _onResetPhoneNumber() {
    _phoneNumberController.clear();
    setState(() {
      _phoneNumber = "";
      _phoneValidationError = null;
      _provider = null;
    });
  }

  String? get _errorMsgInput {
    switch (_phoneValidationError) {
      case (PhoneValidationError.empty): 
        return null;

      case (PhoneValidationError.invalidCharacter):
        return "Nomor hanphone hanya berisi angka";
      
      case (PhoneValidationError.invalidPrefix):
        return "Masukkan nomor yang valid";

      case (PhoneValidationError.invalidLength):
        return null;
      
      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TelcoModel> tempPulsa = [
      TelcoModel(
        id: '1', 
        type: TelcoType.pulsa, 
        nominal: '15rb', 
        price: 'Rp16.000', 
        provider: 'Telkomsel', 
        isDiscount: false
      ),
      TelcoModel(
        id: '2', 
        type: TelcoType.pulsa, 
        nominal: '20rb', 
        price: 'Rp21.000', 
        provider: 'Telkomsel', 
        isDiscount: true
      ),
      TelcoModel(
        id: '3', 
        type: TelcoType.pulsa, 
        nominal: '25rb', 
        price: '25.000', 
        provider: 'Telkomsel', 
        isDiscount: false
      ),
    ];
    
    List<TelcoModel> tempPaketData = [
      TelcoModel(
        id: '1', 
        type: TelcoType.data, 
        description: 'Paket Seru Bulanan Internet 6 GB Selama 30 hari',
        nominal: 'Kuota 6 GB', 
        price: 'Rp55.000', 
        provider: 'Telkomsel', 
        isDiscount: false
      ),
      TelcoModel(
        id: '2', 
        type: TelcoType.data, 
        description: 'Paket Seru Bulanan Internet 6 GB Selama 30 hari',
        nominal: 'Kuota 6 GB', 
        price: 'Rp55.000', 
        provider: 'Telkomsel', 
        isDiscount: true
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "Pulsa & Data",
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
          child: Divider(height: 1.0, thickness: 1.0, color: Color(0xFFDDDDDD),)
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _InputNumberPhoneField(
              controller: _phoneNumberController,
              provider: _provider,
              onChanged: _onPhoneNumberChanged,
              onReset: _onResetPhoneNumber,
              errorText: _errorMsgInput
            ),
            TabBarSection(
              controller: _tabController,
              tabs: ["Pulsa", "Paket Data"]
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _PulsaList(
                    listPulsa: tempPulsa,
                    phoneNumber: _phoneNumber,
                  ),
                  _PaketDataList(
                    listPaketData: tempPaketData,
                    phoneNumber: _phoneNumber,
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}

class _InputNumberPhoneField extends StatelessWidget {
  const _InputNumberPhoneField({
    required this.controller,
    required this.provider,
    required this.onChanged,
    required this.onReset,
    required this.errorText
  });

  final TextEditingController controller;
  final ProviderModel? provider;
  final void Function(String value) onChanged;
  final void Function() onReset;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final selectedProvider = provider;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nomor Handphone",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.black.withValues(alpha: 0.8)
            )
          ),

          SizedBox(height: 8.0),
          
          TextField(
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(12)
            ],
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600
            ),
            decoration: InputDecoration(
              hintText: "Masukkan nomor handphone",
              hintStyle: TextStyle(
                fontSize: 16.0,
                color: Colors.black.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 14.0),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 8.0),
                child: selectedProvider == null ? 
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedContact02,
                    color: Colors.black.withValues(alpha: 0.6),
                    size: 24.0
                  ) :
                  Image.asset("assets/${selectedProvider.logoAsset}",
                    semanticLabel: "Logo ${selectedProvider.name}",
                    width: 24.0,
                    height: 24.0,
                    fit: BoxFit.contain,
                  )
              )
              ,
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: controller.text.isNotEmpty ? Padding(
                padding: EdgeInsets.only(left: 8.0, right: 16.0),
                child: GestureDetector(
                  onTap: onReset, 
                  child: CircleAvatar(
                    radius: 10.0,
                    backgroundColor: Colors.black.withValues(alpha: 0.4),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 16.0
                    )
                  )
                ),
              ) : SizedBox(),
              suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
              enabledBorder: _border(Color(0xFFDDDDDD)),
              focusedBorder: _border(Theme.of(context).colorScheme.primary),
              border: _border(Color(0xFFDDDDDD))
            )
          ),

          // === Error Message ===
          if (errorText != null) ...[
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withValues(alpha: 0.05)
              ),
              child: Text(
                errorText ?? "",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Theme.of(context).colorScheme.error
                )
              )
            )
          ]
        ],
      )
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: color, width: 1.0)
  );
}

class _PulsaList extends StatelessWidget {
  const _PulsaList({
    required this.listPulsa,
    required this.phoneNumber
  });

  final List<TelcoModel> listPulsa;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    if (phoneNumber.isEmpty) {
      return _EmptyTelcoState();
    }
    if (listPulsa.isEmpty) {
      return Center(
        child: Text(
          "Paket pulsa tidak ditemukan"
        )
      );
    }

    return ListView.separated(
      itemCount: (listPulsa.length / 2).ceil(),
      separatorBuilder: (_, __) => SizedBox(), 
      itemBuilder: (context, rowIndex) {
        final int firstIndex = rowIndex * 2;
        final int secondIndex = firstIndex + 1;
    
        return Padding(
          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Row(
            children: [
              Expanded(child: _PulsaTile(
                dataPulsa: listPulsa[firstIndex],
                onTap: () => {}
              )),
              SizedBox(width: 16.0),
              Expanded(
                child: secondIndex < listPulsa.length ? 
                  _PulsaTile(
                    dataPulsa: listPulsa[secondIndex],
                    onTap: () => {}
                  ):
                  SizedBox()
              )
            ],
          ),
        );
      }, 
    );
  }
}

class _PulsaTile extends StatelessWidget {
  const _PulsaTile({
    required this.dataPulsa,
    required this.onTap
  });

  final TelcoModel dataPulsa;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        onTap: () => onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFDDDDDD),
              width: 2.0
            ),
            borderRadius: BorderRadius.circular(12.0)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.0,
            children: [
              Text(
                dataPulsa.nominal,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 0.05
                )
              ),
              Text(
                dataPulsa.price,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 0.05
                )
              )
            ],
          ),
        ),
      )
    );
  }
}

class _PaketDataList extends StatelessWidget {
  const _PaketDataList({
    required this.listPaketData,
    required this.phoneNumber
  });

  final List<TelcoModel> listPaketData;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    if (phoneNumber.isEmpty) {
      return _EmptyTelcoState();
    }
    if (listPaketData.isEmpty) {
      return Center(
        child: Text(
          "Paket data tidak ditemukan"
        )
      );
    }

    return ListView.separated(
      itemCount: listPaketData.length,
      separatorBuilder: (_, __) => SizedBox(), 
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: _PaketDataTile(paketData: listPaketData[index]),
        );
      }, 
    );
  }
}

class _PaketDataTile extends StatelessWidget {
  const _PaketDataTile({required this.paketData});

  final TelcoModel paketData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, 
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
          child: InkWell(
            onTap: () => {},
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              padding: paketData.isDiscount ? 
                EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 24.0) :
                EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFDDDDDD),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12.0)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paketData.description ?? paketData.nominal,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                    )
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    paketData.nominal,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black
                    )
                  ),
                  SizedBox(height: 6.0),
                  Row(
                    spacing: 10.0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "30 Hari",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withValues(alpha: 0.6)
                        ),
                      ),
                      Text(
                        paketData.price,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary
                        )
                      )
                    ]
                  )
                ]
              )
            ),
          ),
        ),
        
        paketData.isDiscount ? 
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0)
              )
            ),
            child: Text("Promo",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              )
            )
          )
        ) : SizedBox(),

        paketData.isDiscount ? 
        Positioned(
          top: 0,
          right: -6.0,
          child: Container(
            width: 6.0,
            height: 34.0,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(4.0),
                bottomRight: Radius.circular(4.0)
              )
            )
          )
        ) : SizedBox(),
      ],
    );
  }
}

class _EmptyTelcoState extends StatelessWidget {
  const _EmptyTelcoState();

  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 12.0),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                "assets/phone_cell.svg",
                semanticsLabel: "Phone Cell",
                width: 60.0,
              ),
            ),
            Text("Masukkan nomor handphone terlebih dahulu",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
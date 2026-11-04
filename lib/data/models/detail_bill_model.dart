import 'package:smile_cell/data/models/telco_model.dart';
import 'package:smile_cell/helpers/format_currency.dart';

enum BillType {
  phoneCredit("phone credit"),
  package("package"),
  pdam("pdam"),
  pln("pln"),
  bpjs("bpjs"),
  sendBalance("send balance");

  const BillType(this.label);
  final String label;
}

class BillProduct {
  final String name;
  final BillType category;
  final String description;
  final String imageAsset;

  const BillProduct({
    required this.name,
    required this.category,
    required this.description,
    required this.imageAsset,
  });

  String get imagePath => "assets/$imageAsset";
}

class BillInformation {
  final String key;
  final String value;

  const BillInformation({
    required this.key,
    required this.value
  });
}

sealed class BillDetail {
  const BillDetail();

  // Nomor pdam, bpjs, pln, hp
  String get targetNumber;

  List<BillInformation> get informations;
}

class PdamDetail extends BillDetail {
  final String customerId;
  final String customerName;
  final String region;

  const PdamDetail({
    required this.customerId,
    required this.customerName,
    required this.region
  });

  @override
  String get targetNumber => customerId;

  @override
  List<BillInformation> get informations => [
    BillInformation(key: "Nama Pelanggan", value: customerName),
    BillInformation(key: "Nomor Pelanggan", value: customerId),
    BillInformation(key: "Wilayah", value: region),
  ];
}

class PlnDetail extends BillDetail {
  final String customerId;
  final String customerName;

  const PlnDetail({
    required this.customerId,
    required this.customerName,
  });

  @override
  String get targetNumber => customerId;

  @override
  List<BillInformation> get informations => [
    BillInformation(key: "Nama Pelanggan", value: customerName),
    BillInformation(key: "Nomor Pelanggan", value: customerId),
  ];
}

class BpjsDetail extends BillDetail {
  final String customerId;
  final String customerName;

  const BpjsDetail({
    required this.customerId,
    required this.customerName,
  });

  @override
  String get targetNumber => customerId;

  @override
  List<BillInformation> get informations => [
    BillInformation(key: "Nama Pelanggan", value: customerName),
    BillInformation(key: "Nomor Pelanggan", value: customerId),
  ];
}

class PhoneCreditDetail extends BillDetail {
  final String phoneNumber;
  final int nominal; // jumlah pulsa
  final TypeProvider provider;

  const PhoneCreditDetail({
    required this.phoneNumber,
    required this.nominal,
    required this.provider
  });

  @override
  String get targetNumber => phoneNumber;

  @override
  List<BillInformation> get informations => [
    BillInformation(key: "Nomor Handphone", value: phoneNumber),
    BillInformation(key: "Nominal", value: formatIdr(nominal))
  ];
}

class PackageDetail extends BillDetail {
  final String phoneNumber;
  final int nominal; // jumlah kuota berapa mb/gb
  final int days;
  final TypeProvider provider;

  const PackageDetail({
    required this.phoneNumber,
    required this.nominal,
    required this.days,
    required this.provider
  });

  @override
  String get targetNumber => phoneNumber;

  @override
  List<BillInformation> get informations => [
    BillInformation(key: "Nomor Handphone", value: phoneNumber),
    BillInformation(key: "Nominal Kuota", value: "$nominal GB"),
    BillInformation(key: "Masa Aktif", value: "$days hari")
  ];
}

class SendBalanceDetail extends BillDetail {
  final String phoneNumber;
  final String customerAgent;
  final String customerName;
  final int amount;

  const SendBalanceDetail({
    required this.phoneNumber,
    required this.customerAgent,
    required this.customerName,
    required this.amount
  });

  @override
  String get targetNumber => phoneNumber;

  @override
  List<BillInformation> get informations => [
    BillInformation(key: "Nomor Handphone", value: phoneNumber),
    BillInformation(key: "Nominal Kirim", value: formatIdr(amount) ?? "-")
  ];
}

class PaymentSummary {
  final int amount;
  final int discount;
  final int fee;

  const PaymentSummary({
    required this.amount,
    required this.discount,
    required this.fee
  }); 

  int get totalAmount => amount - discount + fee;
}

class BillInquiry {
  final BillProduct product;
  final BillDetail details;
  final PaymentSummary payment;

  const BillInquiry({
    required this.product,
    required this.details,
    required this.payment
  });
}
import "package:smile_cell/config/bill_config.dart";
import "package:smile_cell/data/models/detail_bill_model.dart";
import "package:smile_cell/data/models/telco_model.dart";
import "package:smile_cell/data/models/transaction_model.dart";
import "package:smile_cell/services/phone_provider_detector.dart";

const _fallbackLogo = "Vector.png";

const _monthNames = [
  "Januari",
  "Februari",
  "Maret",
  "April",
  "Mei",
  "Juni",
  "Juli",
  "Agustus",
  "September",
  "Oktober",
  "November",
  "Desember",
];

String logoFromPhoneNumber(String number) {
  return PhoneProviderDetector.detect(number)?.logoAsset ?? _fallbackLogo;
}

// ---------------------------------------------------------------------------
// Produk
// ---------------------------------------------------------------------------
 
final _plnProduct = BillProduct(
  name: "PLN",
  category: BillType.pln,
  description: "Pembayaran tagihan listrik",
  imageAsset: BillCategories.pln.logoAsset,
);
 
final _pdamProduct = BillProduct(
  name: "PDAM",
  category: BillType.pdam,
  description: "Pembayaran tagihan air",
  imageAsset: BillCategories.pdam.logoAsset,
);
 
final _bpjsProduct = BillProduct(
  name: "BPJS",
  category: BillType.bpjs,
  description: "Pembayaran iuran BPJS Kesehatan",
  imageAsset: BillCategories.bpjs.logoAsset,
);
 
/// Logo pulsa/kuota mengikuti operator dari nomor HP
BillProduct _phoneCreditProduct(String phoneNumber) => BillProduct(
      name: "Pulsa",
      category: BillType.phoneCredit,
      description: "Isi ulang pulsa",
      imageAsset: logoFromPhoneNumber(phoneNumber),
    );
 
BillProduct _packageProduct(String phoneNumber) => BillProduct(
      name: "Paket Data",
      category: BillType.package,
      description: "Pembelian paket data internet",
      imageAsset: logoFromPhoneNumber(phoneNumber),
    );
 
final _sendBalanceProduct = BillProduct(
  name: "Kirim Saldo",
  category: BillType.sendBalance,
  description: "Kirim saldo e-wallet",
  imageAsset: "profile_default.png",
);
 
// ---------------------------------------------------------------------------
// Helper agar setiap data dummy tetap ringkas
// ---------------------------------------------------------------------------
 
TransactionModel _trx({
  required String id,
  required String date,
  required TransactionStatus status,
  required BillProduct product,
  required BillDetail details,
  required int amount,
  int fee = 0,
  int discount = 0,
}) {
  return TransactionModel(
    id: id,
    date: DateTime.parse(date),
    status: status,
    bill: BillInquiry(
      product: product,
      details: details,
      payment: PaymentSummary(amount: amount, discount: discount, fee: fee),
    ),
  );
}
 
// ---------------------------------------------------------------------------
// Data dummy
// Total (amount - discount + fee) sama dengan amount di data lama.
// ---------------------------------------------------------------------------
 
final dummyTransactions = <TransactionModel>[
  _trx(
    id: "1",
    date: "2026-05-20 14:22:10",
    status: TransactionStatus.pending,
    product: _plnProduct,
    details: const PlnDetail(
      customerId: "19888753413313",
      customerName: "Budi Santoso",
    ),
    amount: 525500,
    fee: 2500,
  ),
  _trx(
    id: "2",
    date: "2026-05-20 11:08:27",
    status: TransactionStatus.pending,
    product: _packageProduct("081279574783"),
    details: const PackageDetail(
      phoneNumber: "081279574783",
      nominal: 25,
      days: 30,
      provider: TypeProvider.indosat
    ),
    amount: 65000,
  ),
  _trx(
    id: "3",
    date: "2026-05-19 08:41:55",
    status: TransactionStatus.pending,
    product: _bpjsProduct,
    details: const BpjsDetail(
      customerId: "13313194447534",
      customerName: "Siti Aminah",
    ),
    amount: 45500,
    fee: 2500,
  ),
  _trx(
    id: "4",
    date: "2026-05-18 17:33:02",
    status: TransactionStatus.pending,
    product: _pdamProduct,
    details: const PdamDetail(
      customerId: "88120394471",
      customerName: "Zaky Ramadhan",
      region: "Surakarta",
    ),
    amount: 135000,
    fee: 2500,
  ),
  _trx(
    id: "5",
    date: "2026-05-18 09:12:44",
    status: TransactionStatus.pending,
    product: _phoneCreditProduct("085712345678"),
    details: const PhoneCreditDetail(
      phoneNumber: "085712345678",
      nominal: 25000,
      provider: TypeProvider.indosat
    ),
    amount: 25000,
  ),
  _trx(
    id: "6",
    date: "2026-05-17 20:05:19",
    status: TransactionStatus.pending,
    product: _plnProduct,
    details: const PlnDetail(
      customerId: "17282916342324",
      customerName: "Dewi Lestari",
    ),
    amount: 99500,
    fee: 2500,
  ),
  _trx(
    id: "7",
    date: "2026-05-17 13:27:36",
    status: TransactionStatus.pending,
    product: _packageProduct("081745329981"),
    details: const PackageDetail(
      phoneNumber: "081745329981",
      nominal: 40,
      days: 30,
      provider: TypeProvider.indosat
    ),
    amount: 89000,
  ),
  _trx(
    id: "8",
    date: "2026-05-16 06:58:13",
    status: TransactionStatus.pending,
    product: _phoneCreditProduct("088123456789"),
    details: const PhoneCreditDetail(
      phoneNumber: "088123456789",
      nominal: 50000,
      provider: TypeProvider.indosat
    ),
    amount: 50000,
  ),
  _trx(
    id: "9",
    date: "2026-05-13 12:09:40",
    status: TransactionStatus.success,
    product: _bpjsProduct,
    details: const BpjsDetail(
      customerId: "13313194447534",
      customerName: "Siti Aminah",
    ),
    amount: 45500,
    fee: 2500,
  ),
  _trx(
    id: "10",
    date: "2026-05-08 09:15:33",
    status: TransactionStatus.success,
    product: _packageProduct("085598127743"),
    details: const PackageDetail(
      phoneNumber: "085598127743",
      nominal: 25,
      days: 30,
      provider: TypeProvider.indosat
    ),
    amount: 70000,
    discount: 5000, // contoh transaksi dengan diskon
  ),
  _trx(
    id: "11",
    date: "2026-05-05 15:44:21",
    status: TransactionStatus.failed,
    product: _pdamProduct,
    details: const PdamDetail(
      customerId: "77201938442",
      customerName: "Agus Prasetyo",
      region: "Sukoharjo",
    ),
    amount: 89500,
    fee: 2500,
  ),
  _trx(
    id: "12",
    date: "2026-04-28 16:48:02",
    status: TransactionStatus.success,
    product: _plnProduct,
    details: const PlnDetail(
      customerId: "198827353814335",
      customerName: "Rina Wulandari",
    ),
    amount: 49500,
    fee: 2500,
  ),
  _trx(
    id: "13",
    date: "2026-04-24 10:19:07",
    status: TransactionStatus.success,
    product: _phoneCreditProduct("082211947365"),
    details: const PhoneCreditDetail(
      phoneNumber: "082211947365",
      nominal: 20000,
      provider: TypeProvider.indosat
    ),
    amount: 20000,
  ),
  _trx(
    id: "14",
    date: "2026-04-20 10:05:19",
    status: TransactionStatus.failed,
    product: _plnProduct,
    details: const PlnDetail(
      customerId: "172829163423246",
      customerName: "Dewi Lestari",
    ),
    amount: 49500,
    fee: 2500,
  ),
  _trx(
    id: "15",
    date: "2026-04-15 07:52:38",
    status: TransactionStatus.success,
    product: _bpjsProduct,
    details: const BpjsDetail(
      customerId: "13998271044521",
      customerName: "Hendra Wijaya",
    ),
    amount: 147500,
    fee: 2500,
  ),
  _trx(
    id: "16",
    date: "2026-04-11 19:03:08",
    status: TransactionStatus.success,
    product: _packageProduct("087812349900"),
    details: const PackageDetail(
      phoneNumber: "087812349900",
      nominal: 75,
      days: 30,
      provider: TypeProvider.indosat
    ),
    amount: 110000,
  ),
  _trx(
    id: "17",
    date: "2026-04-03 08:30:44",
    status: TransactionStatus.failed,
    product: _pdamProduct,
    details: const PdamDetail(
      customerId: "66102938471",
      customerName: "Sri Wahyuni",
      region: "Karanganyar",
    ),
    amount: 76000,
    fee: 2500,
  ),
  _trx(
    id: "18",
    date: "2026-03-27 21:14:52",
    status: TransactionStatus.success,
    product: _plnProduct,
    details: const PlnDetail(
      customerId: "144902837465",
      customerName: "Bambang Hartono",
    ),
    amount: 202500,
    fee: 2500,
  ),
  _trx(
    id: "19",
    date: "2026-03-19 12:41:09",
    status: TransactionStatus.success,
    product: _phoneCreditProduct("085311228877"),
    details: const PhoneCreditDetail(
      phoneNumber: "085311228877",
      nominal: 100000,
      provider: TypeProvider.indosat
    ),
    amount: 100000,
  ),
  _trx(
    id: "20",
    date: "2026-03-08 09:26:15",
    status: TransactionStatus.failed,
    product: _bpjsProduct,
    details: const BpjsDetail(
      customerId: "13445566778899",
      customerName: "Yuni Astuti",
    ),
    amount: 32500,
    fee: 2500,
  ),
  // Tambahan: data lama belum punya contoh kirim saldo
  _trx(
    id: "21",
    date: "2026-03-05 18:20:11",
    status: TransactionStatus.success,
    product: _sendBalanceProduct,
    details: const SendBalanceDetail(
      phoneNumber: "081234567890",
      customerAgent: "DANA",
      customerName: "Fajar Nugroho",
      amount: 100000
    ),
    amount: 100000,
    fee: 1000,
  ),
];

List<TransactionModel> getPendingTransactions(
  List<TransactionModel> transactions,
) {
  return transactions
      .where((item) => item.status == TransactionStatus.pending)
      .toList();
}

List<TransactionModel> getHistoryTransactions(
  List<TransactionModel> transactions,
) {
  final history = transactions
      .where((item) => item.status != TransactionStatus.pending)
      .toList();

  history.sort((a, b) => b.date.compareTo(a.date));

  return history;
}

Map<String, List<TransactionModel>> groupByMonth(
  List<TransactionModel> transactions,
) {
  final grouped = <String, List<TransactionModel>>{};

  for (final transaction in transactions) {
    final date = transaction.date;
    final key = "${_monthNames[date.month - 1]} ${date.year}";

    grouped.putIfAbsent(key, () => []).add(transaction);
  }

  return grouped;
}

String formatTransactionDate(DateTime date) {
  return "${date.day} ${_monthNames[date.month - 1]} ${date.year}";
}
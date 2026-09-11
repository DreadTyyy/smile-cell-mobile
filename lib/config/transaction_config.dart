import "package:smile_cell/config/bill_config.dart";
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

final dummyTransactions = <TransactionModel>[
  TransactionModel(
    id: "1",
    billerName: "PLN",
    number: "19888753413313",
    date: "2026-05-20 14:22:10",
    amount: 528000,
    logoAsset: BillCategories.pln.logoAsset,
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "2",
    billerName: "Paket Data",
    number: "081279574783",
    date: "2026-05-20 11:08:27",
    amount: 65000,
    logoAsset: logoFromPhoneNumber("081279574783"),
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "3",
    billerName: "BPJS",
    number: "13313194447534",
    date: "2026-05-19 08:41:55",
    amount: 48000,
    logoAsset: BillCategories.bpjs.logoAsset,
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "4",
    billerName: "PDAM",
    number: "88120394471",
    date: "2026-05-18 17:33:02",
    amount: 137500,
    logoAsset: BillCategories.pdam.logoAsset,
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "5",
    billerName: "Pulsa",
    number: "085712345678",
    date: "2026-05-18 09:12:44",
    amount: 25000,
    logoAsset: logoFromPhoneNumber("085712345678"),
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "6",
    billerName: "PLN",
    number: "17282916342324",
    date: "2026-05-17 20:05:19",
    amount: 102000,
    logoAsset: BillCategories.pln.logoAsset,
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "7",
    billerName: "Paket Data",
    number: "081745329981",
    date: "2026-05-17 13:27:36",
    amount: 89000,
    logoAsset: logoFromPhoneNumber("081745329981"),
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "8",
    billerName: "Pulsa",
    number: "088123456789",
    date: "2026-05-16 06:58:13",
    amount: 50000,
    logoAsset: logoFromPhoneNumber("088123456789"),
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "9",
    billerName: "BPJS",
    number: "13313194447534",
    date: "2026-05-13 12:09:40",
    amount: 48000,
    logoAsset: BillCategories.bpjs.logoAsset,
    status: TransactionStatus.success,
  ),
  TransactionModel(
    id: "10",
    billerName: "Paket Data",
    number: "085598127743",
    date: "2026-05-08 09:15:33",
    amount: 65000,
    logoAsset: logoFromPhoneNumber("085598127743"),
    status: TransactionStatus.success,
  ),
  TransactionModel(
    id: "11",
    billerName: "PDAM",
    number: "77201938442",
    date: "2026-05-05 15:44:21",
    amount: 92000,
    logoAsset: BillCategories.pdam.logoAsset,
    status: TransactionStatus.failed,
  ),
  TransactionModel(
    id: "12",
    billerName: "PLN",
    number: "198827353814335",
    date: "2026-04-28 16:48:02",
    amount: 52000,
    logoAsset: BillCategories.pln.logoAsset,
    status: TransactionStatus.success,
  ),
  TransactionModel(
    id: "13",
    billerName: "Pulsa",
    number: "082211947365",
    date: "2026-04-24 10:19:07",
    amount: 20000,
    logoAsset: logoFromPhoneNumber("082211947365"),
    status: TransactionStatus.success,
  ),
  TransactionModel(
    id: "14",
    billerName: "PLN",
    number: "172829163423246",
    date: "2026-04-20 10:05:19",
    amount: 52000,
    logoAsset: BillCategories.pln.logoAsset,
    status: TransactionStatus.failed,
  ),
  TransactionModel(
    id: "15",
    billerName: "BPJS",
    number: "13998271044521",
    date: "2026-04-15 07:52:38",
    amount: 150000,
    logoAsset: BillCategories.bpjs.logoAsset,
    status: TransactionStatus.success,
  ),
  TransactionModel(
    id: "16",
    billerName: "Paket Data",
    number: "087812349900",
    date: "2026-04-11 19:03:08",
    amount: 110000,
    logoAsset: logoFromPhoneNumber("087812349900"),
    status: TransactionStatus.success,
  ),
  TransactionModel(
    id: "17",
    billerName: "PDAM",
    number: "66102938471",
    date: "2026-04-03 08:30:44",
    amount: 78500,
    logoAsset: BillCategories.pdam.logoAsset,
    status: TransactionStatus.failed,
  ),
  TransactionModel(
    id: "18",
    billerName: "PLN",
    number: "144902837465",
    date: "2026-03-27 21:14:52",
    amount: 205000,
    logoAsset: BillCategories.pln.logoAsset,
    status: TransactionStatus.success,
  ),
  TransactionModel(
    id: "19",
    billerName: "Pulsa",
    number: "085311228877",
    date: "2026-03-19 12:41:09",
    amount: 100000,
    logoAsset: logoFromPhoneNumber("085311228877"),
    status: TransactionStatus.success,
  ),
  TransactionModel(
    id: "20",
    billerName: "BPJS",
    number: "13445566778899",
    date: "2026-03-08 09:26:15",
    amount: 35000,
    logoAsset: BillCategories.bpjs.logoAsset,
    status: TransactionStatus.failed,
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

  history.sort((a, b) => b.dateTime.compareTo(a.dateTime));

  return history;
}

Map<String, List<TransactionModel>> groupByMonth(
  List<TransactionModel> transactions,
) {
  final grouped = <String, List<TransactionModel>>{};

  for (final transaction in transactions) {
    final date = transaction.dateTime;
    final key = "${_monthNames[date.month - 1]} ${date.year}";

    grouped.putIfAbsent(key, () => []).add(transaction);
  }

  return grouped;
}

String formatTransactionDate(DateTime date) {
  return "${date.day} ${_monthNames[date.month - 1]} ${date.year}";
}
import "package:smile_cell/data/models/transaction_model.dart";

const dummyTransactions = <TransactionModel>[
  TransactionModel(
    id: "1",
    billerName: "BPJS",
    number: "11111111111",
    date: "2026-09-06 12:09:40",
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "2",
    billerName: "PLN",
    number: "22222222222",
    date: "2026-09-06 12:09:40",
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "3",
    billerName: "PDAM",
    number: "33333333333",
    date: "2026-09-06 12:09:40",
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "4",
    billerName: "BPJS",
    number: "44444444444",
    date: "2026-09-06 12:09:40",
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "5",
    billerName: "BPJS",
    number: "55555555555",
    date: "2026-09-06 12:09:40",
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "6",
    billerName: "PLN",
    number: "66666666666",
    date: "2026-09-06 12:09:40",
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "7",
    billerName: "PDAM",
    number: "77777777777",
    date: "2026-09-06 12:09:40",
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "8",
    billerName: "PDAM",
    number: "88888888888",
    date: "2026-09-06 12:09:40",
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: "9",
    billerName: "PLN",
    number: "99999999999",
    date: "2026-09-06 12:09:40",
    status: TransactionStatus.pending,
  ),
];

List<TransactionModel> getPendingTransactions(
  List<TransactionModel> transactions,
) {
  return transactions
      .where((item) => item.status == TransactionStatus.pending)
      .toList();
}
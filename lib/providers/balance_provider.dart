import "package:flutter/foundation.dart";

class BalanceProvider extends ChangeNotifier {
  // TODO: ambil saldo dari database
  final int _balance = 100000;

  int get balance => _balance;
}

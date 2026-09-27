import "package:flutter/foundation.dart";

class BalanceProvider extends ChangeNotifier {
  int _balance = 100000;

  int get balance => _balance;

  bool canSpend(int amount) => amount > 0 && amount <= _balance;

  void topUp(int amount) {
    if (amount <= 0) return;

    _balance += amount;
    notifyListeners();
  }

  bool send(int amount) {
    if (!canSpend(amount)) return false;

    _balance -= amount;
    notifyListeners();
    return true;
  }
}
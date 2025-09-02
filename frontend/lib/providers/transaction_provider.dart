// import 'package:flutter/foundation.dart';

// class Transaction {
//   final String title;
//   final double amount;
//   final bool isIncome;
//   final DateTime date;

//   Transaction({
//     required this.title,
//     required this.amount,
//     required this.isIncome,
//     required this.date,
//   });
// }

// class TransactionProvider with ChangeNotifier {
//   final List<Transaction> _transactions = [];

//   List<Transaction> get transactions => _transactions;

//   double get totalIncome => _transactions
//       .where((t) => t.isIncome)
//       .fold(0, (sum, t) => sum + t.amount);

//   double get totalExpense => _transactions
//       .where((t) => !t.isIncome)
//       .fold(0, (sum, t) => sum + t.amount);

//   void addTransaction(Transaction transaction) {
//     _transactions.add(transaction);
//     notifyListeners();
//   }
// }

// lib/providers/transaction_provider.dart
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  final List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  void addTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }
}

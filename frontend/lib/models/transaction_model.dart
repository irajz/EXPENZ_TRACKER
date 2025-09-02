// lib/models/transaction_model.dart
class TransactionModel {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final bool isExpense;
  final String category;

  TransactionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.isExpense,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'isExpense': isExpense,
      'category': category,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      isExpense: map['isExpense'],
      category: map['category'],
    );
  }
}

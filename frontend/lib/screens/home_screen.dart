// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend/providers/transaction_provider.dart';
// import 'package:frontend/widgets/spend_frequency_chart.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return ListView(
      children: [
        // Spend Frequency Chart
        // SpendFrequencyChart(
        //   income: transactionProvider.totalIncome,
        //   expense: transactionProvider.totalExpense,
        // ),
        // Recent Transactions Section
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Recent Transactions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        if (transactionProvider.transactions.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No transactions yet."),
          )
        // else
        //   ListView.builder(
        //     physics: const NeverScrollableScrollPhysics(),
        //     shrinkWrap: true,
        //     itemCount: transactionProvider.transactions.length,
        //     itemBuilder: (context, index) {
        //       final tx = transactionProvider.transactions[index];
        //       return ListTile(
        //         leading: CircleAvatar(
        //           backgroundColor: tx.isIncome ? Colors.green : Colors.red,
        //           child: Icon(
        //             tx.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
        //             color: Colors.white,
        //           ),
        //         ),
        //         title: Text(tx.title),
        //         subtitle: Text(tx.date.toString().substring(0, 10)),
        //         trailing: Text(
        //           "\$${tx.amount.toStringAsFixed(2)}",
        //           style: TextStyle(
        //             color: tx.isIncome ? Colors.green : Colors.red,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       );
        //     },
        //   ),
      ],
    );
  }
}

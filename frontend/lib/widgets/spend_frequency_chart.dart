import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
// import '../providers/transaction_provider.dart';

class SpendFrequencyChart extends StatelessWidget {
  const SpendFrequencyChart(
      {super.key, required double income, required double expense});

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<TransactionProvider>(context);

    // final income = provider.totalIncome;
    // final expense = provider.totalExpense;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  // value: income.toDouble(),
                  color: Colors.green,
                  title: "Income",
                  radius: 60,
                  titleStyle: const TextStyle(color: Colors.white),
                ),
                PieChartSectionData(
                  // value: expense.toDouble(),
                  color: Colors.red,
                  title: "Expense",
                  radius: 60,
                  titleStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';
import '../model/transaction.dart';

class Chart extends StatelessWidget {
  Chart({required this.transactionsValue});

  final List<Transaction> transactionsValue;

  List<Map<String, Object>> get groupedTransactionsValue {
    return List.generate(7, (index) {
      final weekend = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;
      for (int i = 0; i < transactionsValue.length; i++) {
        if (transactionsValue[i].date.day == weekend.day &&
            transactionsValue[i].date.month == weekend.month &&
            transactionsValue[i].date.year == weekend.year) {
          totalSum += transactionsValue[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekend).substring(0, 1),
        'amount': totalSum,
      };
    });
  }

  double get totalSpending {
    return groupedTransactionsValue.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionsValue);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionsValue.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  label: data['day'].toString(),
                  spendingAmount: (data['amount'] as double),
                  spendingPrctOfTotal: totalSpending == 0.0 ? 0.0 :
                      ((data['amount'] as double) / totalSpending)),
            );
          }).toList().reversed.toList(),
        ),
      ),
    );
  }
}

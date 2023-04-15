import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/widgets/list_transaction_item.dart';
import '../model/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(
    String x,
  ) deleteTx;

  const TransactionList(
      {super.key, required this.transactions, required this.deleteTx});

  @override
  Widget build(BuildContext context) {
    return /*Container(
      height: 300,
      child:*/
        transactions.isEmpty
            ? LayoutBuilder(
                builder: (context, contraint) {
                  return Column(
                    children: [
                      Text(
                        'No transactions are add yet',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 10.00,
                      ),
                      Container(
                        height: contraint.maxHeight * 0.6,
                        child: Image.asset(
                          'assets/images/empty.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  );
                },
              )
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return TransactionItem(transaction: transactions[index], txDelete: deleteTx);
                  /* Card(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15.00, vertical: 10.00),
                      padding: const EdgeInsets.all(10.00),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.00),
                      ),
                      child: Text(
                        '\$${transactions[index].amount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transactions[index].title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          DateFormat.yMMMd().format(transactions[index].date),
                          style: const TextStyle(color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ));*/
                },
                itemCount: transactions.length,
              );
  }
}

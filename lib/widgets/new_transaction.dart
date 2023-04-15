import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function(
    String x,
    double y,
    DateTime Z,
  ) addTx;

  NewTransaction({super.key, required this.addTx}) {}

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? _selectedDate;

  void submitData() {
    if (amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = amountController.text;
    if (enteredTitle.isEmpty ||
        double.parse(enteredAmount) <= 0 ||
        _selectedDate == null) {
      return;
    }
    widget.addTx(enteredTitle, double.parse(enteredAmount), _selectedDate!);
    Navigator.of(context).pop();
  }

  void presentSelectedDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5.00,
        child: Container(
          padding: EdgeInsets.only(top: 10.00,
          left: 10.00,
          right: 10.00,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) => submitData(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(_selectedDate == null
                        ? 'No date chosen yet'
                        : 'Picked date: ${DateFormat.yMd().format(_selectedDate!)}'),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStatePropertyAll(Colors.blue),
                    ),
                    onPressed: presentSelectedDate,
                    child: Text(
                      'Choose date',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                  /* OutlinedButton(
                    onPressed: () {},
                    style:  Border.,
                    child: Text(
                      'Choose date',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )*/
                ],
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black12),
                ),
                onPressed: () {
                  submitData();
                },
                child: const Text(
                  'Add Transaction',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

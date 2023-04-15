import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import 'package:untitled1/widgets/chart.dart';
import 'package:untitled1/widgets/new_transaction.dart';
import 'model/transaction.dart';
import 'widgets/transactions_list.dart';

void main() {
  /* WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
            .copyWith(secondary: Colors.amber),
        fontFamily: 'Quicksand',
        /* textTheme: TextTheme(titleLarge: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 18.00,

        )),*/
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              titleMedium: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen),
            ),
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 20.00,
        )),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    /* Transaction(id: 't1', title: 'lala', amount: 69.45, date: DateTime.now()),
    Transaction(id: 't2', title: 'sara', amount: 24.35, date: DateTime.now()),*/
  ];
  bool _showChart = false;

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(addTx: _addNewTransaction),
        );
      },
    );
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildPortraitMode(
      MediaQueryData mediaQuery, AppBar appbar, Widget listTransactions) {
    return [
      SizedBox(
        height: (mediaQuery.size.height -
                mediaQuery.padding.top -
                appbar.preferredSize.height) *
            0.3,
        child: Chart(transactionsValue: _recentTransactions),
      ),
      listTransactions
    ];
  }

  List<Widget> _buildLandscapeMode(
      MediaQueryData mediaQuery, AppBar appbar, Widget listTransactions) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Show Chart'),
          Switch.adaptive(
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              })
        ],
      ),
      _showChart == true
          ? SizedBox(
              height: (mediaQuery.size.height -
                      mediaQuery.padding.top -
                      appbar.preferredSize.height) *
                  0.7,
              child: Chart(transactionsValue: _recentTransactions),
            )
          : listTransactions,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landSpace =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var appbar = AppBar(
      title: const Text('First Project!'),
      actions: [
        IconButton(
          onPressed: () {
            _startAddNewTransaction(context);
          },
          icon: const Icon(Icons.add),
        )
      ],
    );
    var listTransactions = SizedBox(
      height: (mediaQuery.size.height -
              mediaQuery.padding.top -
              appbar.preferredSize.height) *
          0.7,
      child: TransactionList(
        transactions: _userTransactions,
        deleteTx: deleteTransaction,
      ),
    );

    return Scaffold(
      appBar: appbar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (landSpace)
                ..._buildLandscapeMode(mediaQuery, appbar, listTransactions),
              if (!landSpace)
                ..._buildPortraitMode(mediaQuery, appbar, listTransactions),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                _startAddNewTransaction(context);
              },
            ),
    );
  }
}

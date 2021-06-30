import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_finances/components/chart.dart';
import 'dart:math';
import 'components/transaction_list.dart';
import 'models/transaction.dart';
import 'components/transaction_form.dart';

main() => runApp(PersonalFinancial());

class PersonalFinancial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Roboto',
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          )),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _transactions.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(
        newTransaction,
      );
    });

    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  _opentransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  Widget _getIconButton(IconData icon, Function fn) {
    return Platform.isIOS
        ? GestureDetector(onTap: fn, child: Icon(icon))
        : IconButton(
            icon: Icon(
              _showChart ? Icons.list : Icons.pie_chart,
            ),
            onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final chartList =
        Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

    final actions = <Widget>[
      _getIconButton(_showChart ? iconList : chartList, () {
        setState(() {
          _showChart = !_showChart;
        });
      }),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _opentransactionFormModal(context),
      ),
    ];
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Despesas Pessoais'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          )
        : AppBar(
            title: Text(
              'Despesas Pessoais',
              style: TextStyle(
                fontSize: 20 * MediaQuery.of(context).textScaleFactor,
              ),
            ),
            actions: actions);

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_showChart || !isLandscape)
              Container(
                  height: availableHeight * (isLandscape ? 0.7 : 0.3),
                  child: Chart(_recentTransactions)),
            if (!_showChart || isLandscape)
              Column(
                children: <Widget>[
                  Container(
                      height: availableHeight * (isLandscape ? 1 : 0.7),
                      child:
                          TransactionList(_transactions, _deleteTransaction)),
                ],
              ),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _opentransactionFormModal(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}

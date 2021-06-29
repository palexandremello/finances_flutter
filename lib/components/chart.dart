import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finances/components/chart_bar.dart';
import 'package:personal_finances/models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentsTransactions;
  Chart(this.recentsTransactions);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;
      for (var i = 0; i < recentsTransactions.length; i++) {
        bool sameDay = recentsTransactions[i].date.day == weekDay.day;
        bool sameMonth = recentsTransactions[i].date.month == weekDay.month;
        bool sameYear = recentsTransactions[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentsTransactions[i].value;
        }
      }
      return {'day': DateFormat.E().format(weekDay)[0], 'value': totalSum};
    });
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, transaction) {
      return sum + transaction['value'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((transactions) {
            double value = (transactions['value'] as double) / _weekTotalValue;
            print(value.isNaN);
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: transactions['day'],
                value: transactions['value'],
                percentage: value.isNaN ? 0 : value,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

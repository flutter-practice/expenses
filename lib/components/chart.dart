import 'package:expenses/components/chart_bar.dart';
import 'package:expenses/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Expense> recentExpenses;

  Chart(this.recentExpenses);

  List<Map<String, Object>> get groupedExpenses {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;

      for (var i = 0; i < recentExpenses.length; i++) {
        bool isSameDay = recentExpenses[i].date.day == weekDay.day;
        bool isSameMonth = recentExpenses[i].date.month == weekDay.month;
        bool isSameYear = recentExpenses[i].date.year == weekDay.year;

        if (isSameDay && isSameMonth && isSameYear)
          totalSum += recentExpenses[i].value;
      }

      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
    }).reversed.toList();
  }

  double get _weekTotalValue {
    return groupedExpenses.fold(0.0, (sum, item) {
      return sum + item['value'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedExpenses.map((exp) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: exp['day'],
                value: exp['value'],
                percentage: _weekTotalValue == 0
                    ? 0
                    : (exp['value'] as double) / _weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

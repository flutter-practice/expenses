import 'dart:math';

import 'package:expenses/components/expense_form.dart';
import 'package:expenses/components/expense_list.dart';
import 'package:flutter/material.dart';
import 'models/expense.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _expenses = [
    Expense(id: '1', title: 'PC', value: 550, date: DateTime.now()),
    Expense(id: '2', title: 'Monitor', value: 90, date: DateTime.now()),
  ];

  _addExpense(String title, double value) {
    final newExpense = Expense(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
      _expenses.add(newExpense);
    });

    Navigator.of(context).pop();
  }

  _openExpenseFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return ExpenseForm(_addExpense);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal expenses'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _openExpenseFormModal(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Card(
                color: Colors.blue,
                child: Text('Graph'),
                elevation: 5,
              ),
            ),
            ExpenseList(_expenses),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openExpenseFormModal(context),
      ),
    );
  }
}

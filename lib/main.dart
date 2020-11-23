import 'dart:io';
import 'dart:math';
import 'package:expenses/components/chart.dart';
import 'package:expenses/components/expense_form.dart';
import 'package:expenses/components/expense_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/expense.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            button: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Expense> _expenses = [];
  bool _showChart = true;

  List<Expense> get _recentExpenses {
    return _expenses.where((exp) {
      return exp.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addExpense(String title, double value, DateTime date) {
    final newExpense = Expense(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _expenses.add(newExpense);
    });

    Navigator.of(context).pop();
  }

  _removeExpense(String id) {
    setState(() {
      _expenses.removeWhere((item) => item.id == id);
    });
  }

  _openExpenseFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return ExpenseForm(_addExpense);
      },
    );
  }

  Widget _getIconButton(IconData icon, Function fn) {
    return Platform.isIOS
        ? GestureDetector(onTap: fn, child: Icon(icon))
        : IconButton(icon: Icon(icon), onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    // App bar icons
    final iconList = Platform.isIOS ? CupertinoIcons.list_bullet : Icons.list;
    final iconChart =
        Platform.isIOS ? CupertinoIcons.chart_bar : Icons.show_chart;
    // App bar actions
    final actions = [
      if (isLandscape)
        _getIconButton(
          _showChart ? iconList : iconChart,
          () => {
            setState(() => {_showChart = !_showChart})
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openExpenseFormModal(context),
      )
    ];
    // App bar
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          )
        : AppBar(
            title: Text('Personal expenses'),
            actions: actions,
          );

    // Calc available height on screen
    final double statusBarHeight = mediaQuery.padding.top;
    final availableHeight =
        mediaQuery.size.height - appBar.preferredSize.height - statusBarHeight;
    // Page body
    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_showChart || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 0.8 : 0.25),
                child: Chart(_recentExpenses),
              ),
            if (!_showChart || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 1 : 0.75),
                child: ExpenseList(_expenses, _removeExpense),
              ),
          ],
        ),
      ),
    );

    // Build app
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _openExpenseFormModal(context),
            ),
          );
  }
}

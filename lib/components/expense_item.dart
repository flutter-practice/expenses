import 'package:expenses/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final void Function(String p1) onRemove;

  const ExpenseItem({
    Key key,
    @required this.expense,
    @required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('${expense.value} €'),
            ),
          ),
        ),
        title: Text(
          expense.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat('d MMM y').format(expense.date),
        ),
        trailing: MediaQuery.of(context).size.width > 400
            ? FlatButton.icon(
                onPressed: () => onRemove(expense.id),
                icon: Icon(Icons.delete),
                label: Text('Remove'),
                textColor: Theme.of(context).errorColor,
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => onRemove(expense.id),
              ),
      ),
    );
  }
}

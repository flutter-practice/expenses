import 'package:expenses/components/adaptatives/adaptative_button.dart';
import 'package:expenses/components/adaptatives/adaptative_datepicker.dart';
import 'package:expenses/components/adaptatives/adaptative_input.dart';
import 'package:flutter/material.dart';

class ExpenseForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  ExpenseForm(this.onSubmit);

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    // input validation
    if (title.isEmpty || value <= 0 || _selectedDate == null) return;

    widget.onSubmit(title, value, _selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            AdaptativeInput(
              controller: _titleController,
              onSubmitted: (_) => _submitForm(),
              label: 'Title',
            ),
            AdaptativeInput(
              controller: _valueController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitForm(),
              label: 'Value (€)',
            ),
            AdaptativeDatePicker(
              selectedDate: _selectedDate,
              onDateChanged: (newDate) {
                setState(() => {_selectedDate = newDate});
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AdaptativeButton(
                  label: 'New expense',
                  onPressed: _submitForm,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

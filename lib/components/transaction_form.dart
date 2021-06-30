import 'package:flutter/material.dart';
import 'adaptative_button.dart';
import 'adaptative_text_field.dart';
import 'adaptative_date_picker.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;
  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();

  final _valueController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }
    widget.onSubmit(title, value, _selectedDate);
  }

  _onChangedDate(newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: 10 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: <Widget>[
              AdaptativeTextField(
                label: 'Título',
                controller: _titleController,
                onSubmitted: (_) => _submitForm(),
              ),
              AdaptativeTextField(
                label: 'Valor (R\$)',
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                controller: _valueController,
                onSubmitted: (_) => _submitForm(),
              ),
              AdaptativeDatePicker(
                selectedDate: _selectedDate,
                onDateChanged: _onChangedDate,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AdaptativeButton(
                    label: 'Nova Transação',
                    onPressed: _submitForm,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

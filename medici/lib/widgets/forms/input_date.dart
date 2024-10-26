import 'package:flutter/material.dart';

class InputDate extends StatefulWidget {
  const InputDate(
      {super.key, required this.label, required this.requiredField});

  final String label;
  final bool requiredField;

  @override
  State<InputDate> createState() => _InputDate();
}

class _InputDate extends State<InputDate> {
  final TextEditingController _textInput = TextEditingController();

  @override
  void dispose() {
    _textInput.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    if (!widget.requiredField) return null;

    if (value == null || value.isEmpty) {
      return widget.label + " Inválido";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> openDateDialog(event) async {
      DateTime? date = await showDatePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(2999),
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.light().copyWith(
                  buttonTheme:
                      const ButtonThemeData(buttonColor: Colors.black)),
              child: child!);
        },
      );

      final selectedDate =
          date?.toString().split(' ')[0].split('-').reversed.join('/');

      if (selectedDate == null || selectedDate.isEmpty) return;

      _textInput.text = selectedDate;
    }

    return TapRegion(
        onTapInside: openDateDialog,
        child: TextFormField(
          keyboardType: TextInputType.datetime,
          enabled: true,
          showCursor: false,
          autocorrect: false,
          controller: _textInput,
          validator: _validate,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            labelText: widget.requiredField ? widget.label + "*" : widget.label,
            border: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: const TextStyle(color: Colors.black),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:medici/datetime_parser.dart';

class InputDate extends StatefulWidget {
  const InputDate(
      {super.key,
      required this.label,
      required this.requiredField,
      required this.callback,
      this.initialValue});

  final String label;
  final String? initialValue;
  final bool requiredField;
  final Function callback;

  @override
  State<InputDate> createState() => _InputDate();
}

class _InputDate extends State<InputDate> {
  final TextEditingController _textInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textInput.text = widget.initialValue ?? '';
  }

  @override
  void dispose() {
    _textInput.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    if (!widget.requiredField) return null;

    if (value == null || value.isEmpty) {
      return "${widget.label} Inválido";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> openDateDialog(event) async {
      DateTime? date = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2999),
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.light().copyWith(
                  buttonTheme:
                      const ButtonThemeData(buttonColor: Colors.black)),
              child: child!);
        },
      );

      if (date == null) return;
      final DateParser selectedDate = DateParser(date);
      _textInput.text = selectedDate.getTimeString();

      widget.callback(selectedDate.getTimeString());
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

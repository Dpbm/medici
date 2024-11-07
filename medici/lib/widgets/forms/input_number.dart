import 'package:flutter/material.dart';

class InputNumber extends StatefulWidget {
  const InputNumber(
      {super.key,
      required this.label,
      required this.requiredField,
      required this.callback,
      this.initialValue});

  final String label;
  final double? initialValue;
  final bool requiredField;
  final Function callback;

  @override
  State<InputNumber> createState() => _InputNumber();
}

class _InputNumber extends State<InputNumber> {
  double value = 0.0;

  String? _validate(String? value) {
    if (!widget.requiredField) return null;

    if (value == null || value.isEmpty || double.parse(value) <= 0.0) {
      return widget.label + " Inválido";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    void _onChange(String? inputVal) {
      if (inputVal == null || inputVal.isEmpty) return;
      double parsedValue = double.parse(inputVal);
      setState(() {
        value = parsedValue;
      });

      widget.callback(parsedValue);
    }

    return TextFormField(
      enabled: true,
      showCursor: true,
      autocorrect: false,
      keyboardType: TextInputType.number,
      cursorColor: Colors.black,
      validator: _validate,
      onChanged: _onChange,
      initialValue: widget.initialValue?.toString(),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: widget.requiredField ? widget.label + "*" : widget.label,
        border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: const TextStyle(color: Color(0xff000000)),
      ),
    );
  }
}

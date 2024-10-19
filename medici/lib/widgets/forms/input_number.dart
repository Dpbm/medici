import 'package:flutter/material.dart';

class InputNumber extends StatefulWidget {
  const InputNumber(
      {super.key, required this.label, required this.requiredField});

  final String label;
  final bool requiredField;

  @override
  State<InputNumber> createState() => _InputNumber();
}

class _InputNumber extends State<InputNumber> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: true,
      showCursor: true,
      autocorrect: false,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        fillColor: const Color(0xffffffff),
        filled: true,
        labelText: widget.requiredField ? widget.label + "*" : widget.label,
        border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: const TextStyle(color: Color(0xff000000)),
      ),
    );
  }
}

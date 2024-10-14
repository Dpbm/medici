import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  const InputText(
      {super.key, required this.label, required this.requiredField});

  final String label;
  final bool requiredField;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: true,
      showCursor: true,
      autocorrect: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        fillColor: const Color(0xffffffff),
        filled: true,
        labelText: requiredField ? label + "*" : label,
        border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: const TextStyle(color: Color(0xff000000)),
      ),
    );
  }
}

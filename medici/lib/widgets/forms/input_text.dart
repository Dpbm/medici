import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  const InputText({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: true,
      showCursor: true,
      autofocus: true,
      autocorrect: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        fillColor: const Color(0xffffffff),
        filled: true,
        border: InputBorder.none,
        labelText: label,
        labelStyle: const TextStyle(color: Color(0x00000000)),
      ),
    );
  }
}

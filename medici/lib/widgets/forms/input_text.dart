import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  const InputText(
      {super.key, required this.label, required this.requiredField});

  final String label;
  final bool requiredField;

  @override
  State<InputText> createState() => _InputText();
}

class _InputText extends State<InputText> {
  String? _validate(String? value) {
    if (!widget.requiredField) return null;

    if (value == null || value.isEmpty) {
      return widget.label + " Inválido";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: true,
      showCursor: true,
      autocorrect: false,
      keyboardType: TextInputType.text,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: widget.requiredField ? widget.label + "*" : widget.label,
        border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      validator: _validate,
    );
  }
}

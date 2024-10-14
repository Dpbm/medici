import 'package:flutter/material.dart';

class InputType extends StatefulWidget {
  const InputType(
      {super.key,
      required this.options,
      required this.label,
      required this.requiredField});

  final List<String> options;
  final String label;
  final bool requiredField;

  @override
  State<InputType> createState() => _InputType();
}

class _InputType extends State<InputType> {
  int selected = 1;

  void setSelectedRadio(int val) {
    setState(() {
      selected = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.label),
        Column(children: [
          RadioListTile<int>(
              title: Text("ML"),
              value: 1,
              groupValue: selected,
              activeColor: Colors.green,
              onChanged: (val) {
                if (val == null) return;
                setSelectedRadio(val);
              }),
          RadioListTile<int>(
              title: Text("ML2"),
              value: 2,
              groupValue: selected,
              activeColor: Colors.blue,
              onChanged: (val) {
                if (val == null) return;
                setSelectedRadio(val);
              })
        ])
      ],
    );
  }
}

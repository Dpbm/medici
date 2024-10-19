import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton(
      {super.key, required this.label, required this.requiredField});

  final String label;
  final bool requiredField;

  @override
  State<SwitchButton> createState() => _SwitchButton();
}

class _SwitchButton extends State<SwitchButton> {
  bool enable = false;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(widget.requiredField ? widget.label + "*" : widget.label,
                style: const TextStyle(fontSize: 16)),
            Switch(
                value: enable,
                activeColor: Colors.green,
                onChanged: (bool value) {
                  setState(() {
                    enable = value;
                  });
                })
          ],
        ));
  }
}

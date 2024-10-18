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
  int selected = 0;

  void setSelectedRadio(int val) {
    setState(() {
      selected = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          Text(widget.label),
          Expanded(
              child: ListView.builder(
                  itemCount: widget.options.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, item) {
                    return Row(
                      children: [
                        Text(widget.options[item]),
                        Radio<int>(
                            value: item,
                            groupValue: selected,
                            activeColor: Colors.green,
                            onChanged: (selectedItem) {
                              if (selectedItem == null) return;
                              setSelectedRadio(selectedItem);
                            })
                      ],
                    );
                  })),
        ],
      ),
    );
  }
}

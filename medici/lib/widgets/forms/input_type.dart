import 'package:flutter/material.dart';

class InputType extends StatefulWidget {
  const InputType(
      {super.key,
      required this.options,
      required this.label,
      required this.requiredField,
      required this.callback
      });

  final List<String> options;
  final String label;
  final bool requiredField;
  final Function callback;

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


    void _onChange(int? selectedItem) {
      if (selectedItem == null) return;
      setSelectedRadio(selectedItem);
      widget.callback(widget.options[selectedItem]);
    }

    return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.requiredField ? widget.label + "*" : widget.label,
            style: const TextStyle(fontSize: 16),
          ),
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
                            onChanged: _onChange)
                      ],
                    );
                  })),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class InputSelect extends StatefulWidget {
  const InputSelect(
      {super.key,
      required this.options,
      required this.label,
      required this.requiredField});

  final List<String> options;
  final String label;
  final bool requiredField;

  @override
  State<InputSelect> createState() => _InputSelect();
}

class _InputSelect extends State<InputSelect> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.options.first;
  }

  void select(String? selection) {
    if (selection == null || selection.isEmpty) return;
    setState(() {
      selected = selection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: const TextStyle(fontSize: 16),
              ),
              DropdownMenu<String>(
                initialSelection: widget.options.first,
                onSelected: select,
                dropdownMenuEntries: widget.options
                    .map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              )
            ],
          ),
        ));
  }
}

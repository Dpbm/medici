import 'package:flutter/material.dart';

class QuantityNotification extends StatefulWidget {
  const QuantityNotification({super.key, required this.doseType});

  final String doseType;

  @override
  State<QuantityNotification> createState() => _QuantityNotification();
}

class _QuantityNotification extends State<QuantityNotification> {
  List<String> threshold = ["4", "5", "10"];
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = threshold.first;
  }

  void select(String? selection) {
    if (selection == null || selection.isEmpty) return;
    setState(() {
      selected = selection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: const Color(0xffffffff),
            borderRadius: BorderRadius.circular(10)),
        child: Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              "Notificar quando restar",
              style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
            ),
            DropdownMenu<String>(
              initialSelection: selected,
              onSelected: select,
              width: 80,
              dropdownMenuEntries:
                  threshold.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
            Text(
              widget.doseType,
              style: const TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
            ),
          ],
        ));
  }
}

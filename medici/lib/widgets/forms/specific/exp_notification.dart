import 'package:flutter/material.dart';

class ExpirationNotification extends StatefulWidget {
  const ExpirationNotification({super.key, this.width});

  final double? width;

  @override
  State<ExpirationNotification> createState() => _ExpirationNotification();
}

class _ExpirationNotification extends State<ExpirationNotification> {
  List<String> threshold = ["3", "4", "5"];
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
        width: widget.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              "Notificar vencimento antes de",
              style: TextStyle(fontSize: 18, fontFamily: 'Montserrat'),
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
            const Text(
              "dias",
              style: TextStyle(fontSize: 18, fontFamily: 'Montserrat'),
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:medici/models/notification_settings.dart';

class ExpirationNotification extends StatefulWidget {
  const ExpirationNotification(
      {super.key, this.width, required this.callback, this.initialValue});

  final double? width;
  final int? initialValue;
  final Function callback;

  @override
  State<ExpirationNotification> createState() => _ExpirationNotification();
}

class _ExpirationNotification extends State<ExpirationNotification> {
  late String selected;

  @override
  void initState() {
    super.initState();
    try {
      selected = expirationOffsets[
          expirationOffsets.indexOf(widget.initialValue.toString())];
    } catch (error) {
      selected = expirationOffsets.first;
    }
  }

  void select(String? selection) {
    if (selection == null || selection.isEmpty) return;
    setState(() {
      selected = selection;
    });
    widget.callback(int.parse(selection));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
              dropdownMenuEntries: expirationOffsets
                  .map<DropdownMenuEntry<String>>((String value) {
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

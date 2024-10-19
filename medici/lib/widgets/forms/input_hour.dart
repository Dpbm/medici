import 'package:flutter/material.dart';

class InputHour extends StatefulWidget {
  const InputHour(
      {super.key, required this.label, required this.requiredField});

  final String label;
  final bool requiredField;

  @override
  State<InputHour> createState() => _InputHour();
}

class _InputHour extends State<InputHour> {
  TimeOfDay selectedHour = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    Future<void> _openTimeDialog(event) async {
      TimeOfDay? hour = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
                data: ThemeData.light().copyWith(
                    buttonTheme:
                        const ButtonThemeData(buttonColor: Color(0xff000000))),
                child: child!);
          });

      if (hour == null) return;
      setState(() {
        selectedHour = hour;
      });
    }

    return TapRegion(
        onTapInside: _openTimeDialog,
        child: TextFormField(
          keyboardType: TextInputType.datetime,
          enabled: false,
          showCursor: false,
          autocorrect: false,
          decoration: InputDecoration(
            fillColor: const Color(0xffffffff),
            filled: true,
            labelText: widget.requiredField ? widget.label + "*" : widget.label,
            border: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: const TextStyle(color: Color(0xff000000)),
          ),
        ));
  }
}

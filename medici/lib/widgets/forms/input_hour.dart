import 'package:flutter/material.dart';

class InputHour extends StatefulWidget {
  const InputHour(
      {super.key,
      required this.label,
      required this.requiredField,
      required this.callback});

  final String label;
  final bool requiredField;
  final Function callback;

  @override
  State<InputHour> createState() => _InputHour();
}

class _InputHour extends State<InputHour> {
  final TextEditingController _hourInputController = TextEditingController();

  @override
  void dispose() {
    _hourInputController.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    if (!widget.requiredField) return null;

    if (value == null || value.isEmpty) {
      return widget.label + " Inválido";
    }
    return null;
  }

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

      _hourInputController.text =
          hour.hour.toString() + ":" + hour.minute.toString();

      widget.callback(hour);
    }

    return TapRegion(
        onTapInside: _openTimeDialog,
        child: TextFormField(
          keyboardType: TextInputType.datetime,
          enabled: true,
          showCursor: false,
          autocorrect: false,
          controller: _hourInputController,
          validator: _validate,
          initialValue: TimeOfDay.now().toString(),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            labelText: widget.requiredField ? widget.label + "*" : widget.label,
            border: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: const TextStyle(color: Color(0xff000000)),
          ),
        ));
  }
}

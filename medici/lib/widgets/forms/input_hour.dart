import 'package:flutter/material.dart';
import 'package:medici/utils/time.dart';

class InputHour extends StatefulWidget {
  const InputHour(
      {super.key,
      required this.label,
      required this.requiredField,
      required this.callback,
      this.initialValue});

  final String label;
  final DateTime? initialValue;
  final bool requiredField;
  final Function callback;

  @override
  State<InputHour> createState() => _InputHour();
}

class _InputHour extends State<InputHour> {
  final TextEditingController _hourInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _hourInputController.text =
        buildTimeString(widget.initialValue ?? DateTime.now());
  }

  @override
  void dispose() {
    _hourInputController.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    if (!widget.requiredField) return null;

    if (value == null || value.isEmpty) {
      return "${widget.label} Inválido";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> openTimeDialog(event) async {
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

      final DateTime now = DateTime.now();
      final DateTime selectedTime =
          DateTime(now.year, now.month, now.day, hour.hour, hour.minute);

      _hourInputController.text = buildTimeString(selectedTime);
      widget.callback(selectedTime);
    }

    return TapRegion(
        onTapInside: openTimeDialog,
        child: TextFormField(
          keyboardType: TextInputType.datetime,
          enabled: true,
          showCursor: false,
          autocorrect: false,
          controller: _hourInputController,
          validator: _validate,
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

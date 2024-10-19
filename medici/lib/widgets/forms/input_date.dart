import 'package:flutter/material.dart';

class InputDate extends StatelessWidget {
  const InputDate(
      {super.key, required this.label, required this.requiredField});

  final String label;
  final bool requiredField;

  @override
  Widget build(BuildContext context) {
    Future<void> _openDateDialog(event) async {
      DateTime? date = await showDatePicker(
        context: context,
        firstDate: DateTime(1990),
        lastDate: DateTime(2999),
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.light().copyWith(
                  buttonTheme:
                      const ButtonThemeData(buttonColor: Color(0xff000000))),
              child: child!);
        },
      );

      final selectedDate = date?.toString().split(' ')[0].split('-').join('/');
    }

    return TapRegion(
        onTapInside: _openDateDialog,
        child: TextFormField(
          keyboardType: TextInputType.datetime,
          enabled: false,
          showCursor: false,
          autocorrect: false,
          decoration: InputDecoration(
            fillColor: const Color(0xffffffff),
            filled: true,
            labelText: requiredField ? label + "*" : label,
            border: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: const TextStyle(color: Color(0xff000000)),
          ),
        ));
  }
}

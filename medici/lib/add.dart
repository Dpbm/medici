import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:medici/widgets/app_bar.dart';
import 'package:medici/widgets/forms/image_area.dart';
import 'package:medici/widgets/forms/input_text.dart';
import 'package:medici/widgets/forms/separator.dart';
import 'package:medici/widgets/return_button.dart';

class Add extends StatefulWidget {
  const Add({super.key, required this.width, required this.height});
  final double height, width;

  @override
  State<Add> createState() => _AddPage();
}

class _AddPage extends State<Add> {
  /* Future<void> _handleDate(event) async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime(2999),
      builder: (BuildContext context, Widget? child) {
        return Theme(
            data: ThemeData.light().copyWith(
                //dialogBackgroundColor: Colors.white,//Background color
                buttonTheme:
                    ButtonThemeData(buttonColor: const Color(0x00000000))),
            child: child!);
      },
    );

    if (date == null) {
      return;
    }

    setState(() {
      selectedDate = date;
    });
  } */

  @override
  Widget build(BuildContext context) {
    final double width = widget.width;
    final double height = widget.height;
    const double topBarSize = 80.0;
    final double bodySize = height - topBarSize;

    return Scaffold(
        appBar: getAppBar(context, const Color(0xffffffff)),
        body: SizedBox(
          width: width,
          height: height,
          child: Column(
            children: [
              Container(
                //topBar
                height: topBarSize,
                width: width,
                padding: const EdgeInsets.all(10),
                color: const Color(0xFFFFFFFF),
                alignment: Alignment.centerLeft,
                child: const ReturnButton(),
              ),
              Container(
                //forms
                margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                child: const Column(children: [
                  ImageArea(),
                  Separator(),
                  InputText(label: "Nome")
                ]),
              ),
              /* Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                child: const TextField(
                  enabled: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Color(0xffffffff),
                    filled: true,
                    hintText: "Nome",
                  ),
                  showCursor: true,
                  autofocus: true,
                  autocorrect: false,
                ),
              ),
              TapRegion(
                  onTapInside: _handleDate,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                    child: InputDatePickerFormField(
                      firstDate: DateTime(1990),
                      lastDate: DateTime(2999),
                      initialDate: selectedDate,
                    ),
                  )) */
            ],
          ),
        ));
  }
}

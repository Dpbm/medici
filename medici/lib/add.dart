import 'package:flutter/material.dart';
import 'package:medici/widgets/app_bar.dart';
import 'package:medici/widgets/forms/image_area.dart';
import 'package:medici/widgets/forms/input_text.dart';
import 'package:medici/widgets/forms/separator.dart';
import 'package:medici/widgets/return_button.dart';
import 'package:medici/widgets/forms/input_date.dart';
import 'package:medici/widgets/forms/input_type.dart';

class Add extends StatefulWidget {
  const Add({super.key, required this.width, required this.height});
  final double height, width;

  @override
  State<Add> createState() => _AddPage();
}

class _AddPage extends State<Add> {
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
                  InputText(
                    label: "Nome",
                    requiredField: true,
                  ),
                  Separator(),
                  InputDate(
                    label: 'Validade',
                    requiredField: true,
                  ),
                  InputType(
                      options: ['comp.', 'ml'],
                      label: 'Tipo de Dose',
                      requiredField: true),
                ]),
              ),
            ],
          ),
        ));
  }
}

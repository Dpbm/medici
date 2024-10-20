import 'package:flutter/material.dart';
import 'package:medici/widgets/app_bar.dart';
import 'package:medici/widgets/forms/image_area.dart';
import 'package:medici/widgets/forms/input_hour.dart';
import 'package:medici/widgets/forms/input_number.dart';
import 'package:medici/widgets/forms/input_select.dart';
import 'package:medici/widgets/forms/input_text.dart';
import 'package:medici/widgets/forms/separator.dart';
import 'package:medici/widgets/forms/specific/exp_notification.dart';
import 'package:medici/widgets/forms/specific/quantity_notification.dart';
import 'package:medici/widgets/forms/submit_button.dart';
import 'package:medici/widgets/forms/switch_button.dart';
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

    final formState = GlobalKey<FormState>();

    return Scaffold(
        appBar: getAppBar(context, const Color(0xffffffff)),
        body: SizedBox(
            width: width,
            height: height,
            child: SingleChildScrollView(
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
                    child: Column(children: [
                      const ImageArea(),
                      const Separator(),
                      const InputText(
                        label: "Nome",
                        requiredField: true,
                      ),
                      const Separator(),
                      const InputDate(
                        label: 'Validade',
                        requiredField: true,
                      ),
                      const Separator(),
                      const InputType(
                          options: ['comp.', 'ml'],
                          label: 'Tipo de Dose',
                          requiredField: true),
                      const Separator(),
                      const InputSelect(options: [
                        '4 em 4h',
                        '6 em 6h',
                        '8 em 8h',
                        '12 em 12h'
                      ], label: 'Frequência', requiredField: true),
                      const Separator(),
                      const InputHour(
                          label: "Horário Inicial", requiredField: true),
                      const Separator(),
                      const SwitchButton(
                          label: "Recorrente", requiredField: true),
                      const Separator(),
                      const InputDate(
                        label: 'Último Dia',
                        requiredField: true,
                      ),
                      const Separator(),
                      const InputNumber(label: "Dose", requiredField: true),
                      const Separator(),
                      const Divider(),
                      const Separator(),
                      const Column(
                        children: [
                          Text(
                            "Configuração de Notificações",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold),
                          ),
                          Separator(),
                          ExpirationNotification(),
                          Separator(),
                          QuantityNotification(doseType: "comp.")
                        ],
                      ),
                      const Separator(),
                      SubmitButton(formState: formState)
                    ]),
                  ),
                ],
              ),
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:medici/models/drug.dart';
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
  final _formState = GlobalKey<FormState>();
  String type = doseTypes.first;
  String? name;
  String? image;
  int? expirationDate;
  int? lastDay;
  double? quantity;
  double? dose;
  String frequency = frequencies.first;
  bool recurrent = false;
  TimeOfDay hour = TimeOfDay.now();

  bool takingPicture = false;

  @override
  Widget build(BuildContext context) {
    final double width = widget.width;
    final double height = widget.height;
    const double topBarSize = 80.0;

    void getName(String inputName) {
      setState(() {
        name = inputName;
      });
    }

    void getExpirationDate(int date) {
      setState(() {
        expirationDate = date;
      });
    }

    void getQuantity(double inputQuantity) {
      setState(() {
        quantity = inputQuantity;
      });
    }

    void getType(String doseType) {
      setState(() {
        type = doseType;
      });
    }

    void getDose(double inputDose) {
      setState(() {
        dose = inputDose;
      });
    }

    void getRecurrent(bool isRecurrent) {
      setState(() {
        recurrent = isRecurrent;
      });
    }

    void getFrequency(String inputFrequency) {
      setState(() {
        frequency = inputFrequency;
      });
    }

    void getImage(String image) {
      setState(() {
        image = image;
      });
    }

    void getHour(TimeOfDay inputHour) {
      setState(() {
        hour = inputHour;
      });
    }

    void getLastDay(int inputLastDay) {
      setState(() {
        lastDay = inputLastDay;
      });
    }

    void _submit() {
      //const Drug data = Drug(name: name, expirationDate: expirationDate, quantity: quantity, doseType: type, dose: dose)
    }

    return Scaffold(
        appBar: getAppBar(context, const Color(0xffffffff)),
        body: SizedBox(
            width: width,
            height: height,
            child: Form(
                key: _formState,
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
                          ImageArea(
                            callback: getImage,
                          ),
                          const Separator(),
                          InputText(
                              label: "Nome",
                              requiredField: true,
                              callback: getName),
                          const Separator(),
                          InputDate(
                              label: 'Validade',
                              requiredField: true,
                              callback: getExpirationDate),
                          const Separator(),
                          InputNumber(
                              label: "Qtde. Total",
                              requiredField: true,
                              callback: getQuantity),
                          const Separator(),
                          InputType(
                              options: doseTypes,
                              label: 'Tipo de Dose',
                              requiredField: true,
                              callback: getType),
                          const Separator(),
                          InputNumber(
                              label: "Dose",
                              requiredField: true,
                              callback: getDose),
                          const Separator(),
                          InputSelect(
                              options: frequencies,
                              label: 'Frequência',
                              requiredField: true,
                              callback: getFrequency),
                          const Separator(),
                          InputHour(
                              label: "Horário Inicial",
                              requiredField: true,
                              callback: getHour),
                          const Separator(),
                          SwitchButton(
                              callback: getRecurrent,
                              label: "Recorrente",
                              requiredField: true),
                          const Separator(),
                          recurrent
                              ? Container()
                              : InputDate(
                                  label: 'Último Dia',
                                  requiredField: true,
                                  callback: getLastDay,
                                ),
                          const Separator(),
                          const Divider(),
                          const Separator(),
                          Column(
                            children: [
                              const Text(
                                "Configuração de Notificações",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold),
                              ),
                              const Separator(),
                              ExpirationNotification(width: width),
                              const Separator(),
                              QuantityNotification(doseType: type, width: width)
                            ],
                          ),
                          const Separator(),
                          SubmitButton(
                            formState: _formState,
                            callback: _submit,
                          )
                        ]),
                      ),
                    ],
                  ),
                ))));
  }
}

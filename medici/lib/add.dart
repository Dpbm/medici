import 'package:flutter/material.dart';
import 'package:medici/models/alert.dart';
import 'package:medici/models/drug.dart';
import 'package:medici/models/notification_settings.dart';
import 'package:medici/utils/db.dart';
import 'package:medici/utils/alerts.dart';
import 'package:medici/utils/leaflet.dart';
import 'package:medici/utils/notifications.dart';
import 'package:medici/utils/time.dart';
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
import 'package:fluttertoast/fluttertoast.dart';

class Add extends StatefulWidget {
  const Add(
      {super.key,
      required this.width,
      required this.height,
      required this.db,
      required this.notifications});
  final double height, width;
  final DB db;
  final NotificationService notifications;

  @override
  State<Add> createState() => _AddPage();
}

class _AddPage extends State<Add> {
  final _formState = GlobalKey<FormState>();
  String type = doseTypes.first;
  String? name;
  String? image;
  String? expirationDate;
  String? lastDay;
  double? quantity;
  double? dose;
  String frequencyString = frequencies.keys.toList().first;
  int frequency = frequencies.values.toList().first;
  bool recurrent = false;
  TimeOfDay hour = TimeOfDay.now();
  int expirationOffset = int.parse(expirationOffsets.first);
  int quantityOffset = int.parse(quantityOffsets.first);

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

    void getExpirationDate(String date) {
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
      if (!frequencies.containsKey(inputFrequency)) return;

      setState(() {
        frequency = frequencies[inputFrequency]!;
        frequencyString = inputFrequency;
      });
    }

    void getImage(String inputImage) {
      setState(() {
        image = inputImage;
      });
    }

    void getHour(TimeOfDay inputHour) {
      setState(() {
        hour = inputHour;
      });
    }

    void getLastDay(String inputLastDay) {
      setState(() {
        lastDay = inputLastDay;
      });
    }

    void getExpirationOffset(int offset) {
      setState(() {
        expirationOffset = offset;
      });
    }

    void getQuantityOffset(int offset) {
      setState(() {
        quantityOffset = offset;
      });
    }

    Future<void> submit() async {
      try {
        final String? leaflet = await getLeaflet(name!);

        final startingTime = buildTimeString(hour);

        Drug data = Drug(
            name: name!,
            image: image,
            expirationDate: expirationDate!,
            quantity: quantity!,
            doseType: type,
            dose: dose!,
            recurrent: recurrent,
            lastDay: lastDay,
            leaflet: leaflet,
            status: 'current',
            frequency: frequencyString,
            startingTime: startingTime);

        final int drugId = await widget.db.addDrug(data);

        NotificationSettings notification = NotificationSettings(
            drugId: drugId,
            expirationOffset: expirationOffset,
            quantityOffset: quantityOffset);

        await widget.db.addNotification(notification);

        List<String> hours = getAlerts(hour, frequency);
        List<Alert> alerts = hours
            .map((hour) => Alert(drugId: drugId, time: hour, status: 'pending'))
            .toList();

        List<int> alertsIds = await widget.db.addAlerts(alerts);

        for (int i = 0; i < hours.length; i++) {
          final TimeOfDay time = parseStringTime(hours[i]);
          await widget.notifications.scheduleDrug(
              DateTime.now()
                  .add(Duration(hours: time.hour, minutes: time.minute)),
              drugId,
              name!,
              dose!,
              type,
              alertsIds[i]);
        }

        Fluttertoast.showToast(
            msg: "Medicamento adicionado com sucesso!",
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);

        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (error) {
        Fluttertoast.showToast(
            msg:
                "Falha ao tentar adicionar o medicamento. Por favor, tente novamente mais tarde!",
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

    return Scaffold(
        appBar: getAppBar(context, Colors.white),
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
                        color: Colors.white,
                        alignment: Alignment.centerLeft,
                        child: ReturnButton(
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Container(
                        //forms
                        margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                        child: Column(children: [
                          ImageArea(
                            callback: getImage,
                            width: width,
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
                              requiredField: false,
                              callback: getType),
                          const Separator(),
                          InputNumber(
                              label: "Dose",
                              requiredField: true,
                              callback: getDose),
                          const Separator(),
                          InputSelect(
                              options: frequencies.keys.toList(),
                              label: 'Frequência',
                              requiredField: false,
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
                              requiredField: false),
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
                              ExpirationNotification(
                                  width: width, callback: getExpirationOffset),
                              const Separator(),
                              QuantityNotification(
                                  doseType: type,
                                  width: width,
                                  callback: getQuantityOffset)
                            ],
                          ),
                          const Separator(),
                          SubmitButton(
                            formState: _formState,
                            callback: submit,
                          )
                        ]),
                      ),
                    ],
                  ),
                ))));
  }
}

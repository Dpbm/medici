import 'package:flutter/material.dart';
import 'package:medici/models/alert.dart';
import 'package:medici/models/drug.dart';
import 'package:medici/models/notification_settings.dart';
import 'package:medici/utils/db.dart';
import 'package:medici/utils/alerts.dart';
import 'package:medici/utils/leaflet.dart';
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

class EditDrug extends StatefulWidget {
  const EditDrug(
      {super.key,
      required this.width,
      required this.height,
      required this.db,
      required this.drug});
  final double height, width;
  final DB db;
  final FullDrug drug;

  @override
  State<EditDrug> createState() => _EditDrugPage();
}

class _EditDrugPage extends State<EditDrug> {
  final _formState = GlobalKey<FormState>();
  String? type, name, expirationDate, frequencyString, image, lastDay, status;
  double? quantity, dose;
  int? frequency, expirationOffset, quantityOffset, id;
  bool? recurrent;
  TimeOfDay? hour;

  bool takingPicture = false;

  @override
  void initState() {
    super.initState();

    type = widget.drug.doseType;
    name = widget.drug.name;
    expirationDate = widget.drug.expirationDate;
    frequencyString = widget.drug.frequency;
    image = widget.drug.image;
    lastDay = widget.drug.lastDay;
    status = widget.drug.status;
    quantity = widget.drug.quantity;
    dose = widget.drug.dose;
    recurrent = widget.drug.recurrent;
    expirationOffset = widget.drug.notification.expirationOffset;
    quantityOffset = widget.drug.notification.quantityOffset;
    id = widget.drug.id;

    final splitTime = widget.drug.startingTime.split(':');

    frequency = frequencies[frequencyString];
    hour = TimeOfDay(
        hour: int.parse(splitTime[0]), minute: int.parse(splitTime[1]));
  }

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
        await widget.db.deleteAlerts(id!);
        await widget.db.deleteNotificationSettings(id!);

        final String? leaflet = await getLeaflet(name!);
        final String startingTime = buildTimeString(hour!);

        Drug data = Drug(
            id: id!,
            name: name!,
            image: image,
            expirationDate: expirationDate!,
            quantity: quantity!,
            doseType: type!,
            dose: dose!,
            recurrent: recurrent!,
            lastDay: lastDay,
            leaflet: leaflet,
            status: status!,
            frequency: frequencyString!,
            startingTime: startingTime);

        NotificationSettings notification = NotificationSettings(
            drugId: id!,
            expirationOffset: expirationOffset!,
            quantityOffset: quantityOffset!);

        await widget.db.updateDrug(data);
        await widget.db.addNotification(notification);

        List<String> hours = getAlerts(hour!, frequency!);
        List<Alert> alerts = hours
            .map((hour) => Alert(drugId: id!, time: hour, status: 'pending'))
            .toList();
        await widget.db.addAlerts(alerts);

        Fluttertoast.showToast(
            msg: "Medicamento atualizado com sucesso!",
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
                "Falha ao tentar adicionar o medicamento. Lembre-se de Preencher todos os campos Obrigatórios!",
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
                            initialValue: image,
                            width: width,
                          ),
                          const Separator(),
                          InputText(
                              label: "Nome",
                              requiredField: true,
                              callback: getName,
                              initialValue: name),
                          const Separator(),
                          InputDate(
                              label: 'Validade',
                              requiredField: true,
                              callback: getExpirationDate,
                              initialValue: expirationDate),
                          const Separator(),
                          InputNumber(
                              label: "Qtde. Total",
                              requiredField: true,
                              callback: getQuantity,
                              initialValue: quantity),
                          const Separator(),
                          InputType(
                              options: doseTypes,
                              label: 'Tipo de Dose',
                              requiredField: false,
                              callback: getType,
                              initialValue: type),
                          const Separator(),
                          InputNumber(
                              label: "Dose",
                              requiredField: true,
                              callback: getDose,
                              initialValue: dose),
                          const Separator(),
                          InputSelect(
                            options: frequencies.keys.toList(),
                            label: 'Frequência',
                            requiredField: false,
                            callback: getFrequency,
                            initialValue: frequencyString,
                          ),
                          const Separator(),
                          InputHour(
                              label: "Horário Inicial",
                              requiredField: true,
                              callback: getHour,
                              initialValue: hour),
                          const Separator(),
                          SwitchButton(
                              callback: getRecurrent,
                              label: "Recorrente",
                              requiredField: false,
                              initialValue: recurrent),
                          const Separator(),
                          recurrent!
                              ? Container()
                              : InputDate(
                                  label: 'Último Dia',
                                  requiredField: true,
                                  callback: getLastDay,
                                  initialValue: lastDay,
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
                                width: width,
                                callback: getExpirationOffset,
                                initialValue: expirationOffset,
                              ),
                              const Separator(),
                              QuantityNotification(
                                  doseType: type!,
                                  width: width,
                                  callback: getQuantityOffset,
                                  initialValue: quantityOffset)
                            ],
                          ),
                          const Separator(),
                          SubmitButton(
                              formState: _formState,
                              callback: submit,
                              text: 'Atualizar')
                        ]),
                      ),
                    ],
                  ),
                ))));
  }
}

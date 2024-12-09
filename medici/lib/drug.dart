import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medici/datetime_parser.dart';
import 'package:medici/models/alert.dart';
import 'package:medici/models/drug.dart';
import 'package:medici/utils/db.dart';
import 'package:medici/utils/debug.dart';
import 'package:medici/utils/notifications.dart';
import 'package:medici/utils/notifications_ids.dart';
import 'package:medici/widgets/app_bar.dart';
import 'package:medici/widgets/archive_button.dart';
import 'package:medici/widgets/delete_button.dart';
import 'package:medici/widgets/drug_page/drug.dart';
import 'package:medici/widgets/drug_page/error.dart';
import 'package:medici/widgets/edit_button.dart';
import 'package:medici/widgets/return_button.dart';

class DrugPage extends StatefulWidget {
  const DrugPage(
      {super.key,
      required this.width,
      required this.height,
      required this.id,
      required this.db,
      required this.notifications});

  final double width, height;
  final int id;
  final DB db;
  final NotificationService notifications;

  @override
  State<DrugPage> createState() => _DrugPage();
}

class _DrugPage extends State<DrugPage> {
  late Future<void> _data;
  FullDrug? drug;

  bool deleting = false;
  int? id;
  String? status;

  List<String> alertsHours = [];
  List<int> alertsIds = [];

  @override
  void initState() {
    super.initState();
    reload();
  }

  void reload() {
    setState(() {});
    _data = getDrug();
  }

  Future<void> getDrug() async {
    try {
      final FullDrug data =
          await widget.db.getFullDrugData(widget.id, widget.notifications);

      setState(() {
        drug = data;
        status = data.status;
        id = data.id;

        for (final Alert alert in data.schedule) {
          alertsIds.add(alert.id!);
          alertsHours.add(alert.time);
        }
      });

      successLog("Got full drug on Drug Page!");
    } catch (error) {
      logError("Failed on get data from Drug", error.toString());

      Fluttertoast.showToast(
          msg: "Falha ao tentar pegar os dados do seu medicamento!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> archiveDrug() async {
    try {
      await widget.db.archiveDrug(id!);
      await widget.notifications.cancelMultiple(alertsIds);
      await widget.notifications
          .cancelNotification(getExpirationNotificationId(id!));

      Fluttertoast.showToast(
          msg: "Medicamento arquivado com sucesso!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      setState(() {
        status = 'archived';
      });

      successLog("archived drug on Page successfully");
    } catch (error) {
      logError("Failed on archive drug Page", error.toString());
      Fluttertoast.showToast(
          msg: "Falha ao arquivar o seu medicamento!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> unarchiveDrug() async {
    try {
      await widget.db.unarchiveDrug(id!);

      await widget.notifications.scheduleMultiple(
          alertsHours, id!, drug!.name, drug!.dose, drug!.doseType, alertsIds);
      await widget.notifications.scheduleExpiration(
          DateParser.fromString(drug!.expirationDate).getTime(),
          id!,
          drug!.name,
          drug!.notification.expirationOffset);

      Fluttertoast.showToast(
          msg: "Medicamento desarquivado com sucesso!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      setState(() {
        status = 'current';
      });

      successLog("UNarchived on page successfully");
    } catch (error) {
      logError("Failed on UNarchive drug on Page", error.toString());
      Fluttertoast.showToast(
          msg: "Falha ao desarquivar o seu medicamento!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> deleteDrug() async {
    try {
      Fluttertoast.showToast(
          msg: "Deletando medicamento...",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.yellow,
          textColor: Colors.white,
          fontSize: 16.0);

      await widget.db.deleteDrug(id!);
      await widget.notifications.cancelMultiple(alertsIds);
      await widget.notifications
          .cancelNotification(getExpirationNotificationId(id!));

      Fluttertoast.showToast(
          msg: "Medicamento deletado com sucesso!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      successLog("Deleted drug on Page");

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (error) {
      logError("Error during deleting drug on Page", error.toString());
      Fluttertoast.showToast(
          msg: "Falha ao tentar deletar o  seu medicamento!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> goToEdit() async {
    if (!context.mounted) return;

    Navigator.pushNamed(context, 'edit', arguments: {'drug': drug}).then((_) {
      reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = widget.width;
    final double height = widget.height;
    const double topBarSize = 80.0;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: getAppBar(context, Colors.white),
        body: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: [
              Container(
                //topBar
                height: topBarSize,
                width: width,
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReturnButton(
                      onPressed: () => Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        EditButton(
                          onPressed: goToEdit,
                        ),
                        DeleteButton(
                          onPressed: deleteDrug,
                        ),
                        ArchiveButton(
                          onPressed: status != 'archived'
                              ? archiveDrug
                              : unarchiveDrug,
                          active: status == 'archived',
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                      child: FutureBuilder<void>(
                          future: _data,
                          builder: (BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            if (snapshot.hasError ||
                                drug == null ||
                                status == null) {
                              return DrugLoadError(
                                  height: height, width: width);
                            }

                            return DrugData(
                                drug: drug!,
                                width: width,
                                callback: reload,
                                drugStatus: status!);
                          })))
            ],
          ),
        ));
  }
}

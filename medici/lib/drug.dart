import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medici/edit.dart';
import 'package:medici/models/drug.dart';
import 'package:medici/utils/db.dart';
import 'package:medici/widgets/app_bar.dart';
import 'package:medici/widgets/archive_button.dart';
import 'package:medici/widgets/delete_button.dart';
import 'package:medici/widgets/drug_status_indicator.dart';
import 'package:medici/widgets/edit_button.dart';
import 'package:medici/widgets/icons.dart';
import 'package:medici/widgets/return_button.dart';
import 'package:url_launcher/url_launcher.dart';

class DrugPage extends StatefulWidget {
  const DrugPage(
      {super.key,
      required this.width,
      required this.height,
      required this.id,
      required this.db});

  final double width, height;
  final int id;
  final DB db;

  @override
  State<DrugPage> createState() => _DrugPage();
}

class _DrugPage extends State<DrugPage> {
  Future<FullDrug?>? _data;

  bool deleting = false;
  int? id;
  String? status;

  @override
  void initState() {
    super.initState();
    reload();
  }

  void reload() {
    setState(() {});
    _data = getDrug();
  }

  Future<FullDrug?> getDrug() async {
    try {
      return await widget.db.getFullDrugData(widget.id);
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Falha ao tentar pegar os dados do seu medicamento!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      if (context.mounted) {
        Navigator.pop(context);
      }
      return null;
    }
  }

  Future<void> archiveDrug() async {
    try {
      await widget.db.archiveDrug(id!);
      Fluttertoast.showToast(
          msg: "Medicamento arquivado com sucesso!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        status = 'archived';
      });
    } catch (error) {
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
      Fluttertoast.showToast(
          msg: "Medicamento desarquivado com sucesso!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        status = 'current';
      });
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Falha ao desarquivar o seu medicamento!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = widget.width;
    final double height = widget.height;
    const double topBarSize = 80.0;

    final double sectionWidth = width - 40;

    Future<void> goToEdit() async {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditDrug(
                  db: widget.db,
                  width: widget.width,
                  height: widget.height,
                  id: id!))).then((_) {
        reload();
      });
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

        Fluttertoast.showToast(
            msg: "Medicamento deletado com sucesso!",
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);

        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (error) {
        Fluttertoast.showToast(
            msg: "Falha ao tentar deletar o  seu medicamento!",
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

    Future<void> _openLeaflet(String? leaflet) async {
      try {
        if (leaflet == null) {
          throw Exception("Failed to open leaflet! Empty leaflet");
        }

        final success = await launchUrl(Uri.parse(leaflet));
        if (!success) {
          throw Exception("Failed to open leaflet");
        }
      } catch (error) {
        Fluttertoast.showToast(
            msg: "Falha ao Carregar a bula",
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

    Widget renderDrugData(FullDrug data) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.name,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 40,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: data.image != null
                    ? Image.file(File(data.image!),
                        width: sectionWidth, height: 300, fit: BoxFit.cover)
                    : Image.asset('images/remedio_imagem_padrao.png',
                        width: sectionWidth, height: 300, fit: BoxFit.cover),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 10),
              child: Text("Valido até " + data.expirationDate,
                  style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              width: sectionWidth,
              height: data.schedule.length * 55 + 40,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text("Horários",
                      style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold)),
                  Expanded(
                      child: ListView.builder(
                          itemCount: data.schedule.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String timeText = data.schedule[index].time;
                            final String doseDescription =
                                data.dose.toString() + data.doseType;

                            return Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.only(left: 5, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const StatusIndicator(status: "taken"),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            timeText,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Montserrat'),
                                          )),
                                    ],
                                  ),
                                  Text(
                                    doseDescription,
                                    style: const TextStyle(
                                        fontSize: 20, fontFamily: 'Montserrat'),
                                  ),
                                ],
                              ),
                            );
                          }))
                ],
              ),
            ),
            Container(
                alignment: Alignment.centerRight,
                child: Text(
                    "Quantidade disponível: " +
                        data.quantity.round().toString(),
                    style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold))),
            Text("Notificar a faltar de medicamento ao ter apenas " +
                data.notification.quantityOffset.toString() +
                data.doseType),
            Text("Notificar o vencimento do medicamento antes de: " +
                data.notification.expirationOffset.toString() +
                "dias"),
            data.leaflet != null
                ? InkWell(
                    onTap: () async {
                      await _openLeaflet(data.leaflet);
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(10),
                          child: const Row(
                            children: [
                              Text("Consultar Bula",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold)),
                              LocalIcon(
                                name: "link",
                                label: "Link",
                                width: 24,
                                height: 24,
                              )
                            ],
                          )),
                    ))
                : Container()
          ],
        ),
      );
    }

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
                    const ReturnButton(),
                    Row(
                      children: [
                        EditButton(
                          onPressed: goToEdit,
                        ),
                        DeleteButton(
                          onPressed: deleteDrug,
                        ),
                        ArchiveButton(
                            onPressed: status == null || status == 'current'
                                ? archiveDrug
                                : unarchiveDrug)
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                      child: FutureBuilder<FullDrug?>(
                          future: _data,
                          builder: (BuildContext context,
                              AsyncSnapshot<FullDrug?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            if (!snapshot.hasData ||
                                snapshot.hasError ||
                                snapshot.data == null) {
                              return Container(
                                  alignment: Alignment.center,
                                  height: height - 100,
                                  width: width,
                                  child: const Text(
                                    "Erro. Por favor tente novamente mais tarde!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.red),
                                  ));
                            }

                            final FullDrug data = snapshot.data!;

                            id = data.id;
                            status = data.status;

                            return renderDrugData(data);
                          })))
            ],
          ),
        ));
  }
}

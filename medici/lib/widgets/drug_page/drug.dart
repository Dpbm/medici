import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medici/models/drug.dart';
import 'package:medici/utils/debug.dart';
import 'package:medici/widgets/drug_status_indicator.dart';
import 'package:medici/widgets/icons.dart';
import 'package:url_launcher/url_launcher.dart';

class DrugData extends StatelessWidget {
  const DrugData(
      {super.key,
      required this.drug,
      required this.width,
      required this.callback,
      required this.drugStatus});

  final FullDrug drug;
  final double width;
  final Function callback;
  final String drugStatus;

  Future<void> openLeaflet(String? leaflet) async {
    try {
      final success = await launchUrl(Uri.parse(leaflet!));
      if (!success) {
        throw Exception("Failed to open leaflet");
      }
    } catch (error) {
      logError("Failed on open leaflet", error.toString());
      Fluttertoast.showToast(
          msg: "Falha ao Carregar a bula",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double sectionWidth = width - 40;

    Future<void> goToEdit() async {
      Navigator.pushNamed(context, 'edit', arguments: {'drug': drug}).then((_) {
        callback();
      });
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(drug.name,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 40,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold)),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: drug.image != null
                  ? Image.file(File(drug.image!),
                      width: sectionWidth, height: 300, fit: BoxFit.cover)
                  : Image.asset('images/remedio_imagem_padrao.png',
                      width: sectionWidth, height: 300, fit: BoxFit.cover),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              drug.recurrent ? const Text("Recorrente") : Container(),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(top: 10),
                child: Text("Valido até ${drug.expirationDate}",
                    style: const TextStyle(
                        fontSize: 11,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          drugStatus == 'expired'
              ? InkWell(
                  onTap: goToEdit,
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: width,
                        margin: const EdgeInsets.only(top: 10),
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                            "Remédio Expirou! Clique para renovar.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                      )))
              : Container(),
          drugStatus == 'refill'
              ? InkWell(
                  onTap: goToEdit,
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: width,
                        margin: const EdgeInsets.only(top: 10),
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                            "Remédio Acabando! Clique para Repor.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                      )),
                )
              : Container(),
          Container(
            width: sectionWidth,
            height: 58 * (drug.schedule.length + 1),
            margin: const EdgeInsets.only(top: 10),
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
                        itemCount: drug.schedule.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String timeText = drug.schedule[index].time;
                          final String timeStatus = drug.schedule[index].status;
                          final String doseDescription =
                              drug.dose.toString() + drug.doseType;

                          return Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 5, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    StatusIndicator(status: timeStatus),
                                    Container(
                                        margin: const EdgeInsets.only(left: 5),
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
              margin: const EdgeInsets.only(top: 10),
              child: Text("Quantidade disponível: ${drug.quantity}",
                  style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold))),
          Text(
            "Notificar a faltar de medicamento ao ter apenas ${drug.notification.quantityOffset}${drug.doseType}",
            style: const TextStyle(fontSize: 10, fontFamily: 'Montserrat'),
          ),
          Text(
              "Notificar o vencimento do medicamento antes de: ${drug.notification.expirationOffset} dias",
              style: const TextStyle(fontSize: 10, fontFamily: 'Montserrat')),
          drug.lastDay != null
              ? Text("Último dia ${drug.lastDay}",
                  style:
                      const TextStyle(fontSize: 14, fontFamily: 'Montserrat'))
              : Container(),
          drug.leaflet != null
              ? InkWell(
                  onTap: () async {
                    await openLeaflet(drug.leaflet);
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
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
}

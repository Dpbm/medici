import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medici/drug.dart';
import 'package:medici/models/drug.dart';
import 'package:medici/utils/db.dart';

class DrugCard extends StatelessWidget {
  final DrugsScheduling data;
  final double width, height;
  final DB db;
  final Function callback;

  const DrugCard(
      {super.key,
      required this.data,
      required this.width,
      required this.height,
      required this.db,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    final List<String> splitTime = data.time.split(':');
    final hour = int.parse(splitTime[0]);
    final timeDiff = hour - TimeOfDay.now().hour;

    return GestureDetector(
        onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => DrugPage(
                        id: data.drugId,
                        width: width,
                        height: height,
                        db: db))).then((_) {
              callback();
            }),
        child: Container(
          height: 120,
          width: width,
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisAlignment: timeDiff < 0
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.all(10),
                  width: 100,
                  child: data.image == null
                      ? Image.asset("images/remedio_imagem_padrao.png",
                          width: 100, height: 100)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(data.image!),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ))),
              Container(
                height: 120,
                width: 180,
                alignment: Alignment.centerLeft,
                child: data.status != 'archived'
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                              data.dose.round().toString() +
                                  " " +
                                  data.doseType,
                              style: const TextStyle(fontSize: 14)),
                          Text(
                              "Em " +
                                  timeDiff.abs().toString() +
                                  " horas - " +
                                  data.time +
                                  "h",
                              style: const TextStyle(fontSize: 14))
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const Text("Arquivado",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.red)),
                        ],
                      ),
              ),
              timeDiff < 0 && data.status != 'archived'
                  ? Container(
                      width: 60,
                      height: 110,
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                    )
                  : const SizedBox(
                      width: 60,
                      height: 110,
                    )
            ],
          ),
        ));
  }
}

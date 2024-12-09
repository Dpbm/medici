import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medici/datetime_parser.dart';
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
    final TimeParser drugTime = TimeParser.fromString(data.alert.time);
    final int timeDiff = drugTime.getAbsHoursDifferenceFromNow();

    final bool isLate = data.alert.status == 'late';

    return GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, 'drug', arguments: {'id': data.id})
                .then((_) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: const EdgeInsets.only(left: 10),
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
                  width: 140,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("${data.dose}${data.doseType}",
                          style: const TextStyle(fontSize: 14)),
                      Text(
                          "${(isLate ? "Atrasado à" : "Em")} $timeDiff horas - ${data.alert.time}h",
                          style: const TextStyle(fontSize: 14))
                    ],
                  )),
              isLate
                  ? Container(
                      width: 60,
                      height: 120,
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                    )
                  : const SizedBox(
                      width: 60,
                      height: 120,
                    )
            ],
          ),
        ));
  }
}

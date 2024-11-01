import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medici/models/drug.dart';

class DrugCard extends StatelessWidget {
  final DrugsScheduling data;

  const DrugCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> splitTime = data.time.split(':');
    final hour = int.parse(splitTime[0]);
    final timeDiff = hour - TimeOfDay.now().hour;

    return Container(
      height: 120,
      margin: const EdgeInsets.all(10),
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
                  ? Image.asset("images/remedio_icone.png", width: 100)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(data.image!),
                        width: 100,
                        fit: BoxFit.cover,
                      ))),
          Container(
            height: 120,
            width: 180,
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(data.dose.round().toString() + " " + data.doseType,
                    style: const TextStyle(fontSize: 14)),
                Text(
                    "Em " +
                        timeDiff.abs().toString() +
                        " horas - " +
                        data.time +
                        "h",
                    style: const TextStyle(fontSize: 14))
              ],
            ),
          ),
          timeDiff < 0
              ? Container(
                  width: 60,
                  height: 120,
                  decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                )
              : Container()
        ],
      ),
    );
  }
}

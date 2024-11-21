import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medici/models/drug.dart';
import 'package:medici/utils/db.dart';

class TinyDrugCard extends StatelessWidget {
  final DrugTinyData data;
  final double width, height;
  final DB db;
  final Function callback;

  const TinyDrugCard(
      {super.key,
      required this.data,
      required this.width,
      required this.height,
      required this.db,
      required this.callback});

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.start,
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
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                    data.name,
                    style: const TextStyle(fontSize: 30),
                  )),
            ],
          ),
        ));
  }
}

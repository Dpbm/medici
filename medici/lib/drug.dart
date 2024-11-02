import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medici/models/drug.dart';
import 'package:medici/utils/db.dart';
import 'package:medici/widgets/app_bar.dart';
import 'package:medici/widgets/archive_button.dart';
import 'package:medici/widgets/delete_button.dart';
import 'package:medici/widgets/edit_button.dart';
import 'package:medici/widgets/return_button.dart';

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

  @override
  Widget build(BuildContext context) {
    final double width = widget.width;
    final double height = widget.height;
    const double topBarSize = 80.0;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: getAppBar(context, Colors.white),
        body: SizedBox(
          width: width,
          height: height,
          child: Column(
            children: [
              Container(
                //topBar
                height: topBarSize,
                width: width,
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                alignment: Alignment.centerLeft,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReturnButton(),
                    Row(
                      children: [EditButton(), DeleteButton(), ArchiveButton()],
                    )
                  ],
                ),
              ),
              FutureBuilder<FullDrug?>(
                  future: _data,
                  builder: (BuildContext context,
                      AsyncSnapshot<FullDrug?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!snapshot.hasData ||
                        snapshot.hasError ||
                        snapshot.data == null) {
                      return const Text("Error");
                    }

                    final FullDrug data = snapshot.data!;

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(data.name),
                          data.image != null
                              ? Image.file(File(data.image!))
                              : Image.asset('images/remedio_icone.png'),
                          Text("Valido até " + data.expirationDate),
                          Text("Quantidade disponível: " +
                              data.quantity.toString()),
                        ],
                      ),
                    );
                  })
            ],
          ),
        ));
  }
}

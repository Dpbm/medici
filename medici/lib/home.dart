import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medici/models/drug.dart';
import 'package:medici/utils/alerts.dart';
import 'package:medici/utils/db.dart';
import 'package:medici/utils/filter_data.dart';
import 'package:medici/widgets/app_bar.dart';
import 'package:medici/widgets/bottom_bar.dart';
import 'package:medici/widgets/drug_card.dart';

class Home extends StatefulWidget {
  const Home(
      {super.key, required this.height, required this.width, required this.db});
  final double height, width;
  final DB db;

  @override
  State<Home> createState() => _HomePage();
}

class _HomePage extends State<Home> {
  Future<void>? _data;
  late List<DrugsScheduling> drugs;
  late List<int> remainingDrugsIndexes;
  late int totalModalsOpen;
  RestartableTimer? timeChecker, listChecker;

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void dispose() {
    resetTimers();
    super.dispose();
  }

  void reload() {
    setState(() {});
    remainingDrugsIndexes = [];
    drugs = [];
    totalModalsOpen = 0;
    resetTimers();
    _data = getDrugs();
  }

  void resetTimers() {
    timeChecker?.cancel();
    listChecker?.cancel();
  }

  void takeMed(int index, String status) async {
    try {
      final int drugIndex = remainingDrugsIndexes[index];

      final DrugsScheduling drug = drugs[drugIndex];

      await widget.db.updateAlertStatus(drug.alert.id!, status);

      setState(() {
        totalModalsOpen -= 1;
        drugs.removeAt(drugIndex);
        remainingDrugsIndexes.removeAt(index);
      });

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Falha ao tentar modificar o status do alerta!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void showModal(int index) {
    final DrugsScheduling drug = drugs[index];

    final String drugName = drug.name;
    final String drugDoseType = drug.doseType;
    final String drugDose = drug.dose.toString();

    final String message = drug.quantity - drug.dose <= 0
        ? 'Você precisa tomar ' +
            drugDose +
            drugDoseType +
            ' de ' +
            drugName +
            ' mas já está chegando próximo do fim, providencie mais o mais rápido possível'
        : "Tomar " + drugDose + " " + drug.doseType + " de " + drug.name;

    showModalBottomSheet<void>(
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return Container(
              height: 300,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message,
                        style: const TextStyle(
                            fontSize: 20, fontFamily: 'Montserrat')),
                    ElevatedButton(
                      onPressed: () => takeMed(index, 'taken'),
                      child: const Text(
                        'Tomar',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () => takeMed(index, 'aware'),
                        child: const Text(
                          'Adiar',
                          style: TextStyle(color: Colors.red),
                        ))
                  ],
                ),
              ));
        });
  }

  void setupPeriodicCheck() {
    final timeCheckerTimer = RestartableTimer(const Duration(minutes: 2), () {
      if (remainingDrugsIndexes.isEmpty) {
        for (final (index, drug) in drugs.indexed) {
          if (itsTimeToTake(drug.alert.time)) {
            setState(() {
              remainingDrugsIndexes.add(index);
            });
          }
        }
      }

      timeChecker?.reset();
    });

    final listCheckerTimer = RestartableTimer(const Duration(seconds: 30), () {
      if (totalModalsOpen <= 0 && remainingDrugsIndexes.isNotEmpty) {
        for (final int index in remainingDrugsIndexes) {
          showModal(index);
          setState(() {
            totalModalsOpen += 1;
          });
        }
      }

      listChecker?.reset();
    });

    setState(() {
      timeChecker = timeCheckerTimer;
      listChecker = listCheckerTimer;
    });
  }

  Future<void> getDrugs() async {
    try {
      final data = await widget.db.getDrugs();
      final filteredData = filterData(data);
      setState(() {
        drugs = filteredData;
      });
      setupPeriodicCheck();
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Falha ao tentar listar seus medicamentos!",
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
    const double topBarSize = 120;
    const double bottomBarHeight = 140;
    final double bodySize = height - topBarSize - bottomBarHeight;

    Widget noDrugs() {
      return Column(children: [
        SizedBox(
            height: topBarSize,
            child: Container(
              padding: const EdgeInsets.all(30),
              child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Não Tomados",
                      style:
                          TextStyle(fontSize: 40, fontFamily: "Montserrat"))),
            )),
        SizedBox(
          height: bodySize,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/fundo_home.png"),
              const Text("Nenhum remédio a tomar!",
                  style: TextStyle(fontFamily: "Montserrat", fontSize: 36),
                  textAlign: TextAlign.center)
            ],
          ),
        )
      ]);
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: getAppBar(context),
        body: SizedBox(
          width: width,
          height: height,
          child: FutureBuilder<void>(
              future: _data,
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.hasError || drugs.isEmpty) {
                  return noDrugs();
                }

                return Column(
                  children: [
                    SizedBox(
                        height: topBarSize,
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Não Tomados",
                                  style: TextStyle(
                                      fontSize: 40, fontFamily: "Montserrat"))),
                        )),
                    Expanded(
                        child: ListView.builder(
                            itemCount: drugs.length,
                            itemBuilder: (BuildContext context, int index) {
                              DrugsScheduling drug = drugs[index];
                              return DrugCard(
                                  data: drug,
                                  width: width,
                                  height: height,
                                  db: widget.db,
                                  callback: reload);
                            }))
                  ],
                );
              }),
        ),
        bottomNavigationBar: BottomBar(
          selected: 0,
          width: width,
          height: height,
          db: widget.db,
          callback: reload,
        ));
  }
}

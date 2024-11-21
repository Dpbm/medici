import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medici/models/drug.dart';
import 'package:medici/utils/alerts.dart';
import 'package:medici/utils/db.dart';
import 'package:medici/utils/debug.dart';
import 'package:medici/utils/filter_data.dart';
import 'package:medici/utils/notifications.dart';
import 'package:medici/widgets/app_bar.dart';
import 'package:medici/widgets/bottom_bar.dart';
import 'package:medici/widgets/drug_card.dart';
import 'package:medici/widgets/home/no_drugs.dart';

class Home extends StatefulWidget {
  const Home(
      {super.key,
      required this.height,
      required this.width,
      required this.db,
      required this.notifications});

  final double height, width;
  final DB db;
  final NotificationService notifications;

  @override
  State<Home> createState() => _HomePage();
}

class _HomePage extends State<Home> {
  Future<void>? _data;

  late List<DrugsScheduling> drugs;
  late List<bool> drugsToTake;
  late int totalModalsOpen;

  Timer? timeChecker, listChecker;

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
    setState(() {
      drugs = [];
      drugsToTake = [];
      totalModalsOpen = 0;
      _data = getDrugs();
    });
    resetTimers();
  }

  void resetTimers() {
    timeChecker?.cancel();
    listChecker?.cancel();
  }

  void closeModal() {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> takeMed(int index, String status) async {
    try {
      final DrugsScheduling drug = drugs[index];

      await widget.db
          .reduceQuantity(drug.id, drug.alert.id!, widget.notifications);
      await widget.db.updateAlertStatus(drug.alert.id!, status);

      successLog("Updated drug Status and quantity from modal!");

      List<bool> updatedToTake = List<bool>.from(drugsToTake);
      updatedToTake.removeAt(index);

      setState(() {
        totalModalsOpen -= 1;
        drugs.removeAt(index);
        drugsToTake = updatedToTake;
      });
    } catch (error) {
      logError("Failed on update drug quantity and status from modal",
          error.toString());
      Fluttertoast.showToast(
          msg: "Falha ao tentar modificar o status do alerta!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      closeModal();
    }
  }

  void showModal(int index) {
    final DrugsScheduling drug = drugs[index];

    final String drugName = drug.name;
    final String drugDoseType = drug.doseType;
    final String drugDose = drug.dose.toString();

    final String message = drug.quantity - drug.dose <= 0
        ? 'Você precisa tomar $drugDose$drugDoseType de $drugName mas já está chegando próximo do fim, reponha o mais rápido possível'
        : "Tomar $drugDose$drugDoseType de $drugName";

    showModalBottomSheet<void>(
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return Container(
              height: 300,
              alignment: Alignment.center,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                          fontSize: 20, fontFamily: 'Montserrat'),
                      textAlign: TextAlign.center,
                    ),
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
    final timeCheckerTimer =
        Timer.periodic(const Duration(seconds: 3), (Timer clock) {
      final bool nothingToTake = drugsToTake.every((index) => !index);

      if (nothingToTake) {
        for (final (index, drug) in drugs.indexed) {
          if (itsTimeToTake(drug.alert.time)) {
            setState(() {
              drugsToTake[index] = true;
            });
          }
        }
      }
    });

    final listCheckerTimer =
        Timer.periodic(const Duration(seconds: 5), (Timer clock) {
      final bool hasToBeTaken = drugsToTake.any((index) => index);

      if (totalModalsOpen <= 0 && hasToBeTaken) {
        for (final (index, haveToTake) in drugsToTake.indexed) {
          if (!haveToTake) continue;

          showModal(index);
          setState(() {
            totalModalsOpen += 1;
          });
        }
      }
    });

    setState(() {
      timeChecker = timeCheckerTimer;
      listChecker = listCheckerTimer;
    });
  }

  Future<void> getDrugs() async {
    try {
      final List<DrugsScheduling> data =
          await widget.db.getDrugs(widget.notifications);

      final List<DrugsScheduling> filteredData = filterData(data);

      successLog("Got filtered data successfully at Home Screen");

      setState(() {
        drugs = filteredData;
        drugsToTake = List<bool>.filled(filteredData.length, false);
      });

      setupPeriodicCheck();

      successLog("Set Periodic check successfully at Home Screen");
    } catch (error) {
      logError("Failed on get data at Home Screen", error.toString());
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
                  return NoDrugs(topBarSize: topBarSize, bodySize: bodySize);
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

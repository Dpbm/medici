import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medici/models/drug.dart';
import 'package:medici/utils/db.dart';
import 'package:medici/widgets/app_bar.dart';
import 'package:medici/widgets/bottom_bar.dart';
import 'package:medici/widgets/tiny_drug_card.dart';

class DrugsList extends StatefulWidget {
  const DrugsList(
      {super.key, required this.height, required this.width, required this.db});
  final double height, width;
  final DB db;

  @override
  State<DrugsList> createState() => _DrugsListPage();
}

class _DrugsListPage extends State<DrugsList> {
  Future<List<DrugTinyData>>? _data;

  @override
  void initState() {
    super.initState();
    reload();
  }

  void reload() {
    setState(() {});
    _data = getDrugs();
  }

  Future<List<DrugTinyData>> getDrugs() async {
    try {
      return await widget.db.getAllDrugs();
    } catch (error) {
      debugPrint("Get Drugs list error: $error");

      Fluttertoast.showToast(
          msg: "Falha ao tentar listar seus medicamentos!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      return [];
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
                  child: Text("Seus remédios",
                      style:
                          TextStyle(fontSize: 40, fontFamily: "Montserrat"))),
            )),
        SizedBox(
          height: bodySize,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/lista_remedios.png",
                width: width - 80,
              ),
              const Text("Nenhum medicamento adicionado!",
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
          child: FutureBuilder<List<DrugTinyData>>(
              future: _data,
              builder: (BuildContext context,
                  AsyncSnapshot<List<DrugTinyData>> snapshot) {
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
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
                              child: Text("Seus remédios",
                                  style: TextStyle(
                                      fontSize: 40, fontFamily: "Montserrat"))),
                        )),
                    Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              DrugTinyData drug = snapshot.data![index];
                              return TinyDrugCard(
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
          selected: 2,
          width: width,
          height: height,
          db: widget.db,
          callback: reload,
        ));
  }
}

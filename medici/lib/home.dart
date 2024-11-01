import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medici/models/drug.dart';
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
  Future<List<DrugsScheduling>>? _data;

  @override
  void initState() {
    super.initState();
    reload();
  }

  void reload() {
    setState(() {});
    _data = getDrugs();
  }

  Future<List<DrugsScheduling>> getDrugs() async {
    try {
      final data = await widget.db.getDrugs();
      return filterData(data);
    } catch (error) {
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
          child: FutureBuilder<List<DrugsScheduling>>(
              future: _data,
              builder: (BuildContext context,
                  AsyncSnapshot<List<DrugsScheduling>> snapshot) {
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
                              child: Text("Não Tomados",
                                  style: TextStyle(
                                      fontSize: 40, fontFamily: "Montserrat"))),
                        )),
                    Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              DrugsScheduling drug = snapshot.data![index];
                              return DrugCard(data: drug);
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

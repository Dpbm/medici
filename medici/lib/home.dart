import 'package:flutter/material.dart';
import 'package:medici/utils/db.dart';
import 'package:medici/widgets/app_bar.dart';
import 'package:medici/widgets/bottom_bar.dart';

class Home extends StatefulWidget {
  const Home(
      {super.key, required this.height, required this.width, required this.db});
  final double height, width;
  final DB db;

  @override
  State<Home> createState() => _HomePage();
}

class _HomePage extends State<Home> {
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
          child: Column(children: [
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
          ]),
        ),
        bottomNavigationBar: BottomBar(
          selected: 0,
          width: width,
          height: height,
          db: widget.db,
        ));
  }
}

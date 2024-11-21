import 'package:flutter/widgets.dart';

class NoDrugs extends StatelessWidget {
  const NoDrugs(
      {super.key,
      required this.width,
      required this.topBarSize,
      required this.bodySize});

  final double width, topBarSize, bodySize;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
          height: topBarSize,
          child: Container(
            padding: const EdgeInsets.all(30),
            child: const Align(
                alignment: Alignment.centerLeft,
                child: Text("Seus remédios",
                    style: TextStyle(fontSize: 40, fontFamily: "Montserrat"))),
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
}

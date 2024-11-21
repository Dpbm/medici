import 'package:flutter/widgets.dart';

class NoDrugs extends StatelessWidget {
  const NoDrugs({super.key, required this.topBarSize, required this.bodySize});

  final double topBarSize, bodySize;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
          height: topBarSize,
          child: Container(
            padding: const EdgeInsets.all(30),
            child: const Align(
                alignment: Alignment.centerLeft,
                child: Text("Não Tomados",
                    style: TextStyle(fontSize: 40, fontFamily: "Montserrat"))),
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
}

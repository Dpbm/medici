import 'package:flutter/material.dart';
import 'package:medici/add.dart';
import 'package:medici/widgets/app_bar.dart';
import 'package:medici/widgets/icons.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  final double height = 0;
  final double width = 0;

  @override
  State<Home> createState() => _HomePage();
}

class _HomePage extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Future<void> goToPage(int index) async {
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Add()));
      setState(() {});
    }

    return Scaffold(
      appBar: getAppBar(context),
      body: SizedBox(
        width: 600,
        height: 1000,
        child: Column(children: [
          SizedBox(
              height: 250,
              child: Container(
                padding: const EdgeInsets.fromLTRB(30, 41, 30, 41),
                child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Não Tomados",
                        style:
                            TextStyle(fontSize: 40, fontFamily: "Montserrat"))),
              )),
          Column(
            children: [
              Image.asset("images/fundo_home.png"),
              const Text("Nenhum remédio tomar!",
                  style: TextStyle(fontFamily: "Montserrat", fontSize: 36),
                  textAlign: TextAlign.center)
            ],
          ),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const LocalIcon(name: "botao_home", label: "Home").active(),
              label: ""),
          const BottomNavigationBarItem(
            icon: LocalIcon(name: "botao_add", label: "Add"),
            label: "",
          ),
          const BottomNavigationBarItem(
              icon: LocalIcon(name: "botao_list", label: "List"), label: "")
        ],
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        onTap: goToPage,
      ),
    );
  }
}

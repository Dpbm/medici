import 'package:flutter/material.dart';
import 'package:medici/add.dart';
import 'package:medici/widgets/app_bar.dart';
import 'package:medici/widgets/icons.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.height, required this.width});
  final double height, width;

  @override
  State<Home> createState() => _HomePage();
}

class _HomePage extends State<Home> {

  @override
  Widget build(BuildContext context) {
    Future<void> goToPage(int index) async {
      await Navigator.push(
          context, MaterialPageRoute(builder: 
						(context) =>  Add(height:widget.height, width:widget.width)
					));
      setState(() {});
    }

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
                    child: Text(
											"Não Tomados",
                      style:
                        TextStyle(fontSize: 40, fontFamily: "Montserrat")
										)
									),
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
import 'package:flutter/material.dart';
import 'package:medici/utils/icons.dart';

class Home extends StatelessWidget{
  const Home ({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SizedBox(
        width: 600,
        height: 1000,
        child: Column(children: [
          Container(
            height: 250,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 41, 30, 41),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Não Tomados",
                        style: TextStyle(fontSize: 40,fontFamily: "Montserrat"),),),
            )
          ),
          Container(
            child: Column(
              children: [
                Image.asset("images/fundo_home.png")
              ],
            ),
          )
        ],),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:  const LocalIcon(name:"botao_home",label: "Home").active(),
            label: ""),
          const BottomNavigationBarItem(
            icon:  LocalIcon(name:"botao_add",label: "Add"), 
            label: ""),
            const BottomNavigationBarItem(
            icon:  LocalIcon(name:"botao_list",label: "List"), 
            label: "")
        ],
        backgroundColor: const Color.fromARGB(255,255,255,255),
      ),
    );
  }
}


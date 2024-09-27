import 'package:flutter/material.dart';
import 'package:medici/utils/icons.dart';

class Home extends StatelessWidget{
  const Home ({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
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


import 'package:flutter/material.dart';
import 'package:medici/drugs_list.dart';
import 'package:medici/home.dart';
import 'package:medici/add.dart';
import 'package:medici/utils/db.dart';
import 'package:medici/widgets/icons.dart';

class BottomBar extends StatelessWidget {
  const BottomBar(
      {super.key,
      required this.selected,
      required this.width,
      required this.height,
      required this.db,
      this.callback});

  final int selected;
  final double width, height;
  final DB db;
  final Function? callback;

  @override
  Widget build(BuildContext context) {
    const List<LocalIcon> icons = [
      LocalIcon(name: "botao_home", label: "Home"),
      LocalIcon(name: "botao_add", label: "Add"),
      LocalIcon(name: "botao_list", label: "List")
    ];

    List<BottomNavigationBarItem> items =
        List<BottomNavigationBarItem>.generate(
            icons.length,
            (index) => BottomNavigationBarItem(
                icon: index == selected ? icons[index].active() : icons[index],
                label: ""));

    void goToPage(int index) {
      if (index == selected) return;

      List<String> routes = ['home', 'add', 'list'];
      Navigator.pushNamed(context, routes[index]).then((_) {
        if (callback != null) {
          callback!();
        }
      });
    }

    return BottomNavigationBar(
      items: items,
      backgroundColor: const Color(0xFFFFFFFF),
      onTap: goToPage,
    );
  }
}

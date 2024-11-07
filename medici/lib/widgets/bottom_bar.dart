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

      MaterialPageRoute<dynamic>? selected_widget =
          null; //TODO: update this later

      switch (index) {
        case 0:
          selected_widget = MaterialPageRoute(
              builder: (context) => Home(
                    width: width,
                    height: height,
                    db: db,
                  ));
          break;
        case 1:
          selected_widget = MaterialPageRoute(
              builder: (context) => Add(width: width, height: height, db: db));
          break;

        case 2:
          selected_widget = MaterialPageRoute(
              builder: (context) =>
                  DrugsList(width: width, height: height, db: db));
          break;
        default:
          break;
      }

      if (selected_widget == null) return; //TODO: remove this later

      Navigator.push(context, selected_widget).then((_) {
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

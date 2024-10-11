import 'package:flutter/material.dart';
import 'package:medici/home.dart';
import 'package:medici/add.dart';
import 'package:medici/widgets/icons.dart';

class BottomBar extends StatelessWidget {
  const BottomBar(
      {super.key,
      required this.selected,
      required this.width,
      required this.height});

  final int selected;
  final double width, height;

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

    Future<void> goToPage(int index) async {
      if (index == selected) return;

      MaterialPageRoute<dynamic>? selected_widget =
          null; //TODO: update this later

      switch (index) {
        case 0:
          selected_widget = MaterialPageRoute(
              builder: (context) => Home(
                    width: width,
                    height: height,
                  ));
          break;
        case 1:
          selected_widget = MaterialPageRoute(
              builder: (context) => Add(width: width, height: height));
          break;
        default:
          break;
      }

      if (selected_widget == null) return; //TODO: remove this later

      await Navigator.push(context, selected_widget);
    }

    return BottomNavigationBar(
      items: items,
      backgroundColor: const Color(0xFFFFFFFF),
      onTap: goToPage,
    );
  }
}

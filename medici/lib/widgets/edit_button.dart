import 'package:flutter/material.dart';
import 'package:medici/widgets/icons.dart';

class EditButton extends StatelessWidget {
  const EditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const LocalIcon(name: "edit", label: "Editar"),
        onPressed: () => Navigator.pop(context));
  }
}

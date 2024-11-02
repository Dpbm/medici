import 'package:flutter/material.dart';
import 'package:medici/widgets/icons.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const LocalIcon(name: "lixeira", label: "Deletar"),
        onPressed: () => Navigator.pop(context));
  }
}

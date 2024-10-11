import 'package:flutter/material.dart';
import 'package:medici/widgets/icons.dart';

class ReturnButton extends StatelessWidget {
  const ReturnButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const LocalIcon(name: "botao_voltar", label: "Return"),
        onPressed: () => Navigator.pop(context));
  }
}

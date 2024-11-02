import 'package:flutter/material.dart';
import 'package:medici/widgets/icons.dart';

class ArchiveButton extends StatelessWidget {
  const ArchiveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const LocalIcon(name: "arquivar", label: "Arquivar"),
        onPressed: () => Navigator.pop(context));
  }
}

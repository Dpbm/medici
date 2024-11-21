import 'package:flutter/material.dart';
import 'package:medici/widgets/icons.dart';

class ArchiveButton extends StatelessWidget {
  const ArchiveButton(
      {super.key, required this.active, required this.onPressed});

  final bool active;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          onPressed();
        },
        icon: active
            ? const LocalIcon(name: "arquivar", label: "Arquivar").active()
            : const LocalIcon(name: "arquivar", label: "Arquivar"));
  }
}

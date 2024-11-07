import 'package:flutter/material.dart';
import 'package:medici/widgets/icons.dart';

class ArchiveButton extends IconButton {
  const ArchiveButton({super.key, required super.onPressed})
      : super(icon: const LocalIcon(name: "arquivar", label: "Arquivar"));
}

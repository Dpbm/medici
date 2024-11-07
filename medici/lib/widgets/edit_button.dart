import 'package:flutter/material.dart';
import 'package:medici/widgets/icons.dart';

class EditButton extends IconButton {
  const EditButton({super.key, required super.onPressed})
      : super(icon: const LocalIcon(name: "edit", label: "Editar"));
}

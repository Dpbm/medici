import 'package:flutter/material.dart';
import 'package:medici/widgets/icons.dart';

class DeleteButton extends IconButton {
  const DeleteButton({super.key, required super.onPressed})
      : super(icon: const LocalIcon(name: "lixeira", label: "Deletar"));
}

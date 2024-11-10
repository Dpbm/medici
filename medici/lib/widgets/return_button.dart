import 'package:flutter/material.dart';
import 'package:medici/widgets/icons.dart';

class ReturnButton extends IconButton {
  const ReturnButton({super.key, required super.onPressed})
      : super(icon: const LocalIcon(name: "botao_voltar", label: "Return"));
}

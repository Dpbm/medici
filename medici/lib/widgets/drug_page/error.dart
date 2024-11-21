import 'package:flutter/material.dart';

class DrugLoadError extends StatelessWidget {
  const DrugLoadError({super.key, required this.height, required this.width});

  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: height - 100,
        width: width,
        child: const Text(
          "Erro. Por favor tente novamente mais tarde!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, color: Colors.red),
        ));
  }
}

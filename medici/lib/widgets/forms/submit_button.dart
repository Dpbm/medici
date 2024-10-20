import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  const SubmitButton({super.key, required this.formState});

  final GlobalKey<FormState> formState;

  @override
  State<SubmitButton> createState() => _SubmitButton();
}

class _SubmitButton extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(Colors.green),
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
        onPressed: () {},
        child: const Text(
          "Adicionar",
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ));
  }
}

import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  const SubmitButton(
      {super.key, required this.formState, required this.callback});

  final GlobalKey<FormState> formState;
  final Function callback;

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
        onPressed: () {
          bool valid = widget.formState.currentState!.validate();
          if (!valid) return;

          widget.callback();
        },
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

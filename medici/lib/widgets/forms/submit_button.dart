import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  const SubmitButton(
      {super.key, required this.formState, required this.callback, this.text});

  final GlobalKey<FormState> formState;
  final Function callback;
  final String? text;

  @override
  State<SubmitButton> createState() => _SubmitButton();
}

class _SubmitButton extends State<SubmitButton> {
  bool sending = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(sending ? Colors.grey : Colors.green),
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
        onPressed: () async {
          if (sending) return;

          bool valid = widget.formState.currentState!.validate();

          if (!valid) return;

          setState(() {
            sending = true;
          });

          await widget.callback();

          setState(() {
            sending = false;
          });
        },
        child: Text(
          sending ? "Enviando..." : (widget.text ?? "Adicionar"),
          style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ));
  }
}

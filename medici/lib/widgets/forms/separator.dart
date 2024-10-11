import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  const Separator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Colors.transparent,
      thickness: 0,
      height: 20,
    );
  }
}

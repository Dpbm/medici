import 'package:flutter/material.dart';
import 'package:medici/models/alert.dart';

class StatusIndicator extends StatelessWidget {
  const StatusIndicator({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          color: statusesColors[status],
          borderRadius: BorderRadius.circular(100)),
    );
  }
}

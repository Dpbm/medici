import 'package:flutter/material.dart';

PreferredSizeWidget getAppBar(BuildContext context, [color]) {
  
  return PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: AppBar(
        backgroundColor: color ?? Theme.of(context).colorScheme.primary,
        elevation: 0,
      ));
}
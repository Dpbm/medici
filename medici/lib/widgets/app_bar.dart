import 'package:flutter/material.dart';

PreferredSizeWidget getAppBar(BuildContext context) {
  return PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ));
}

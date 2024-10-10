import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocalIcon extends StatelessWidget{
  final String name, label;

  const LocalIcon(
    {super.key,
    required this.name,
    required this.label,
    });

  String buildPath(String status) {
    return 'images/icons/' + name + "_" + status + '.svg';
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      buildPath("default"),
      semanticsLabel: label,
      width: 40,
      height: 40,
    );
  }

  Widget active(){
      return SvgPicture.asset(
      buildPath("active"),
      semanticsLabel: label,
      width: 40,
      height: 40,
    );
  }
}
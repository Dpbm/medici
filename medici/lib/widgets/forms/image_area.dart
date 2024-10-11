import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ImageArea extends StatefulWidget {
  const ImageArea({super.key /* , required this.cameraController */});

  /*  final CameraController cameraController; */

  @override
  State<ImageArea> createState() => _ImageArea();
}

class _ImageArea extends State<ImageArea> {
  Future<void> takePhoto() async {
    try {
      //final picture = await widget.cameraController.takePicture();
    } catch (error) {
      print("Failed on taking picture...");
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 370,
        child: Container(
          padding: const EdgeInsets.fromLTRB(100, 60, 100, 60),
          decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(15)),
          child: GestureDetector(
            onTap: takePhoto,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/adicionar_imagens.jpg"),
                const Text("Adicionar foto do medicamento",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "Montserrat", fontSize: 12))
              ],
            ),
          ),
        ));
  }
}

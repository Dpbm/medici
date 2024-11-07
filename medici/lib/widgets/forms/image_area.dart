import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageArea extends StatefulWidget {
  const ImageArea({super.key, required this.callback, this.initialValue});

  final String? initialValue;
  final Function callback;

  @override
  State<ImageArea> createState() => _ImageArea();
}

class _ImageArea extends State<ImageArea> {
  String? _documentsDir;
  File? _image;

  @override
  void initState() {
    super.initState();
    try {
      _image = File(widget.initialValue!);
    } catch (error) {
      _image = null;
    }
  }

  Future<void> getImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? response =
          await picker.pickImage(source: ImageSource.camera);

      if (response == null) return;

      if (_documentsDir == null) {
        final String appDocumentsDir =
            (await getApplicationDocumentsDirectory()).path;
        setState(() {
          _documentsDir = appDocumentsDir;
        });
      }

      await _image?.delete();

      final String imagePath = path.join(_documentsDir!, response.name);
      print("Saving to: " + imagePath);
      await response.saveTo(imagePath);

      final File file = File(imagePath);

      setState(() {
        _image = file;
      });

      widget.callback(imagePath);
    } catch (error) {
      print("[!] Failed on get image: ");
      print(error);
    }
  }

  Widget noImage() {
    return Container(
      padding: const EdgeInsets.fromLTRB(100, 60, 100, 60),
      decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/adicionar_imagens.jpg"),
          const Text("Adicionar foto do medicamento",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: "Montserrat", fontSize: 12))
        ],
      ),
    );
  }

  Widget loadImage() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.file(
          _image!,
          fit: BoxFit.cover,
          height: 300,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: getImage,
        child: SizedBox(
            width: 370, child: _image == null ? noImage() : loadImage()));

    /*   */
  }
}

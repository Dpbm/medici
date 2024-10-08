import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:medici/widgets/icons.dart';

class Add extends StatelessWidget {
  const Add({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> takePhoto() async {
      try {
        final cameras = await availableCameras();
        final camera = cameras.first;

        final controler = CameraController(camera, ResolutionPreset.medium);
        await controler.initialize();

        final picture = await controler.takePicture();

        await controler.dispose();
      } catch (error) {
        print("OPSS");
      }
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 180,
            width: 1000,
            padding: const EdgeInsets.fromLTRB(30, 41, 30, 41),
            color: const Color(0xFFFFFFFF),
            child: IconButton(
                icon: LocalIcon(name: "botao_voltar", label: "Return"),
                onPressed: () => Navigator.pop(context)),
            alignment: Alignment.bottomLeft,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 430,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                    padding: const EdgeInsets.fromLTRB(80, 60, 80, 60),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(15)),
                    child: GestureDetector(
                      onTap: takePhoto,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("images/adicionar_imagens.jpg"),
                          Text(
                            "Adicionar foto do medicamento",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}

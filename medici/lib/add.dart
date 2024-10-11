import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:medici/widgets/app_bar.dart';
import 'package:medici/widgets/icons.dart';


class Add extends StatefulWidget {
  const Add ({super.key, required this.width, required this.height});
  final double height, width;

  @override
  State<Add> createState() => _AddPage();
}

class _AddPage extends State<Add> {
  bool hasCameraAttached = false;
  late CameraController _cameraController;


  DateTime selectedDate = DateTime.now();



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { _setupCamera(); });
  }

  Future<void> _setupCamera () async{
    try{
      final cameras = await availableCameras();
        if (cameras.isEmpty){
          return;
        }

        hasCameraAttached = true;

        final camera = cameras.first;

        _cameraController = CameraController(
          camera,
          ResolutionPreset.medium,
        );

        await _cameraController.initialize();
    }catch(error){
      print("Setup camera failed...");
      print(error);
    }
   
  }


  Future<void> _handleDate(event) async{
    DateTime? date = await showDatePicker(
        context: context, 
        firstDate: DateTime(1990), 
        lastDate: DateTime(2999),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
            //dialogBackgroundColor: Colors.white,//Background color
              buttonTheme: ButtonThemeData(
                buttonColor: const Color(0x00000000)
              )
              ),
            child: child!
            );
          },
        );

    if(date == null){
      return;
    }

    setState(() {
      selectedDate = date;
    });
  } 

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    Future<void> takePhoto() async{

      try{

        final picture = await _cameraController.takePicture();

      }catch(error){
        print("Failed on taking picture...");
        print(error);
      }



    }

    final width = widget.width;
    final height = widget.height;
    const topBarSize = 80.0;
    final bodySize = height-topBarSize;


    return Scaffold(
      appBar: getAppBar(context,  const Color(0xffffffff)),
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
        children: [
          Container(
            height: topBarSize,
            width: width,
            padding: const EdgeInsets.all(10),
            color: const Color(0xFFFFFFFF),
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const LocalIcon(
                name: "botao_voltar", 
                label: "Return"
              ), 
              onPressed: () => Navigator.pop(context)
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 430,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                  padding: const EdgeInsets.fromLTRB(80, 60, 80, 60),
                  decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius:  BorderRadius.circular(15)),
                  child: GestureDetector(
                    onTap: takePhoto,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Image.asset("images/adicionar_imagens.jpg"),
                      const Text(
                        "Adicionar foto do medicamento", 
                        textAlign:TextAlign.center, 
                        style: TextStyle(fontFamily: "Montserrat", fontSize: 12)
                      )
                    ],
                  ),
                ),
              )
              ),
              
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: const TextField(
              enabled: true,
              keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: Color(0xffffffff),
                  filled: true,
                  hintText: "Nome",
                ),
                showCursor: true,
                autofocus: true,
                autocorrect: false,
              ),
          ),
          TapRegion( 
            onTapInside: _handleDate,
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: InputDatePickerFormField(
                firstDate: DateTime(1990),
                lastDate: DateTime(2999),
                initialDate: selectedDate,
              ),
          ))
        ],
      ),
    ));
  }
}
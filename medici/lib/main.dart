import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medici/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'Medici',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xF2F1E9),
            primary: const Color(0x063E42),
            secondary: const Color(0x90DCC7),
      )),
      home: const Home(),
    );
  }
}


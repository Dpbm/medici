import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medici/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final double heightMarginTop = MediaQuery.of(context).padding.top;
    final double height = MediaQuery.of(context).size.height - heightMarginTop;
    final double width = MediaQuery.of(context).size.width;

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
        home: Home());
  }
}

import 'package:flutter/material.dart';
import '../screens/images.dart';
import '../screens/text.dart';

import 'package:loader_overlay/loader_overlay.dart';

Color azulDestaque = const Color.fromARGB(255, 31, 12, 67);
Color fundo = const Color.fromARGB(255, 238, 237, 242);
Color azulCinza = const Color.fromARGB(255, 207, 213, 225);
Color vermelho = const Color.fromARGB(255, 232, 50, 49);

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF1F0C43, <int, Color>{
          50: Color.fromARGB(255, 31, 12, 67),
          100: Color.fromARGB(255, 31, 12, 67),
          200: Color.fromARGB(255, 31, 12, 67),
          300: Color.fromARGB(255, 31, 12, 67),
          400: Color.fromARGB(255, 31, 12, 67),
          500: Color.fromARGB(255, 31, 12, 67),
          600: Color.fromARGB(255, 31, 12, 67),
          700: Color.fromARGB(255, 31, 12, 67),
          800: Color.fromARGB(255, 31, 12, 67),
          900: Color.fromARGB(255, 31, 12, 67),
        }),
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, child) => LoaderOverlay(child: child!),
      home: TelaImagem(),
    );
  }
}

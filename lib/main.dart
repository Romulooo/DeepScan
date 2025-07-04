import 'package:flutter/material.dart';
import '../screens/images.dart';

Color azulDestaque = const Color.fromARGB(255, 31, 12, 67);
Color fundo = const Color.fromARGB(255, 238, 237, 242);
Color azulCinza = const Color.fromARGB(255, 207, 213, 225);
Color vermelho = const Color.fromARGB(255, 232, 50, 49);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaImagem(), // Aqui vai a sua tela
    );
  }
}

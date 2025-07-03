import 'package:flutter/material.dart';
import '../screens/images.dart';

Color azulDestaque = const Color.fromARGB(255, 31, 12, 67);
Color fundo = const Color.fromARGB(255, 238, 237, 242);
Color azulCinza = const Color.fromARGB(255, 207, 213, 225);

void main() {
  runApp(MaterialApp(home: TelaImagem()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}

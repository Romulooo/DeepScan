import 'package:flutter/material.dart';

class TelaTexto extends StatefulWidget {
  @override
  State<TelaTexto> createState() => _TelaTextoState();
}

class _TelaTextoState extends State<TelaTexto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 31, 12, 67),
        title: Text(
          "DeepScan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: Image.asset('assets/images/Logo-PI.jpg'),
      ),
    );
  }
}

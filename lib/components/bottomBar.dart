import 'package:flutter/material.dart';
import 'package:deepscan/main.dart';
import '../screens/text.dart';
import '../screens/images.dart';

String tela = "image";

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: [
        IconButton(
          onPressed:
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaTexto()),
                ),
                tela = "text",
              },
          icon: Icon(
            tela == "image" ? Icons.text_snippet_outlined : Icons.text_snippet,
            color: azulDestaque,
            size: 30,
          ),
        ),
        IconButton(
          onPressed:
              () => {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => TelaImagem()),
                  (Route route) => false,
                ),
                tela = "image",
              },
          icon: Icon(
            tela == "image" ? Icons.image : Icons.image_outlined,
            color: azulDestaque,
            size: 30,
          ),
        ),
      ],
      backgroundColor: azulCinza,
    );
  }
}

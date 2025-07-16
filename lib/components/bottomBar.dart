import 'package:flutter/material.dart';
import 'package:deepscan/main.dart';
import '../screens/text.dart';
import '../screens/images.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: [
        IconButton(
          onPressed: () => {},
          icon: Icon(
            Icons.text_snippet_outlined,
            color: azulDestaque,
            size: 30,
          ),
        ),
        IconButton(
          onPressed: () => {},
          icon: Icon(Icons.image, color: azulDestaque, size: 30),
        ),
      ],
      backgroundColor: azulCinza,
    );
  }
}

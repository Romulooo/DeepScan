import 'package:flutter/material.dart';
import 'package:deepscan/main.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: azulDestaque,
      title: Text(
        "DeepScan",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [Image.asset('images/Logo.jpg')],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

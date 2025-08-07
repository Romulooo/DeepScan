import 'package:flutter/material.dart';
import 'package:deepscan/main.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: azulDestaque,
      title: Text(
        "DeepScan",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        SizedBox(
          height: 50,
          width: 75,
          child: Image.asset('assets/images/Logo.png'),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';

import 'package:deepscan/main.dart';
import '../components/navBar.dart';
import '../components/bottomBar.dart';

void main() {
  runApp(const TelaImagem());
}

class TelaImagem extends StatefulWidget {
  const TelaImagem({super.key});

  @override
  State<TelaImagem> createState() => _TelaImagemState();
}

class _TelaImagemState extends State<TelaImagem> {
  bool _arquivo = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: fundo,
        appBar: NavBar(),
        body: ListView(
          children: [
            SizedBox(height: 75),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _arquivo ? Icons.file_copy : Icons.link,
                  color: azulDestaque,
                  size: 100,
                ),
                Text(
                  "Verificar \n imagem por \n ${_arquivo ? "Arquivo" : "URL "}",
                  style: TextStyle(
                    color: azulDestaque,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            _arquivo
                ? Text("Arquivo")
                : Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextSelectionTheme(
                          data: TextSelectionThemeData(
                            selectionColor: azulDestaque.withOpacity(0.2),
                            cursorColor: azulDestaque,
                            selectionHandleColor: azulDestaque,
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              floatingLabelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              label: Text("URL da Imagem"),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: azulCinza),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: azulDestaque),
                              ),
                              focusColor: azulDestaque,
                              hoverColor: azulDestaque,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 240,
                        height: 40,
                        child: ElevatedButtonTheme(
                          data: ElevatedButtonThemeData(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: azulDestaque,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () => {},
                            child: Text(
                              "Verificar",
                              style: TextStyle(color: fundo, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            SizedBox(height: 60),
            Switch(
              value: _arquivo,
              onChanged: (value) {
                setState(() {
                  _arquivo = value;
                });
              },
            ),
          ],
        ),

        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}

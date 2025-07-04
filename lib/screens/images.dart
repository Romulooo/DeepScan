import 'package:flutter/material.dart';

import '../logic/imagedetector.dart';

import 'package:deepscan/main.dart';
import '../components/navBar.dart';
import '../components/bottomBar.dart';

import 'package:flutter_popup_card/flutter_popup_card.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:percent_indicator/percent_indicator.dart';

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
  String aiGenerated = "AI Generated";
  String deepfake = "Deepfake";
  final TextEditingController _controllerUrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          controller: _controllerUrl,
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
                          onPressed: () async {
                            final result = await verificarImagem(
                              _controllerUrl.text,
                            );
                            showPopupCard(
                              context: context,
                              builder: (context) {
                                return PopupCard(
                                  elevation: 8,
                                  color: fundo,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(
                                      color: azulCinza,
                                      width: 6.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: SizedBox(
                                      width: 300,
                                      height: 400,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Resultado:",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "images/Deepfake.svg",
                                                width: 50,
                                              ),
                                              LinearPercentIndicator(
                                                width: 200.0,
                                                lineHeight: 20.0,
                                                percent:
                                                    double.tryParse(deepfake) !=
                                                            null
                                                        ? double.parse(
                                                              deepfake,
                                                            ) /
                                                            100
                                                        : 0.0,
                                                backgroundColor: azulCinza,
                                                progressColor: vermelho,
                                              ),
                                              Text(
                                                deepfake.length == 1
                                                    ? "0" + deepfake
                                                    : deepfake,
                                                style: TextStyle(
                                                  color: vermelho,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "%",
                                                style: TextStyle(
                                                  color: vermelho,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 30),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "images/Ai.svg",
                                                width: 50,
                                              ),
                                              LinearPercentIndicator(
                                                width: 200.0,
                                                lineHeight: 20.0,
                                                percent:
                                                    double.tryParse(
                                                              aiGenerated,
                                                            ) !=
                                                            null
                                                        ? double.parse(
                                                              aiGenerated,
                                                            ) /
                                                            100
                                                        : 0.0,
                                                backgroundColor: azulCinza,
                                                progressColor: vermelho,
                                              ),
                                              Text(
                                                aiGenerated.length == 1
                                                    ? "0" + aiGenerated
                                                    : aiGenerated,
                                                style: TextStyle(
                                                  color: vermelho,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "%",
                                                style: TextStyle(
                                                  color: vermelho,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              offset: const Offset(0, 10),
                              alignment: Alignment.center,

                              useSafeArea: true,
                              dimBackground: true,
                            );
                            setState(() {
                              aiGenerated = result[0];
                              deepfake = result[1];
                            });
                          },
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
    );
  }
}

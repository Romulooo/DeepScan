import 'package:flutter/material.dart';
import '../logic/textdetector.dart';

import 'package:deepscan/main.dart';
import '../components/navBar.dart';
import '../components/bottomBar.dart';

import '../logic/infotext.dart';

// Importando o pacote de popup card
import 'package:flutter_popup_card/flutter_popup_card.dart';

// Importando o pacote de ícones SVG
import 'package:flutter_svg/flutter_svg.dart';

// Importando o pacote de indicador de porcentagem
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(const TelaTexto());
}

class TelaTexto extends StatefulWidget {
  const TelaTexto({super.key});

  @override
  State<TelaTexto> createState() => _TelaTextoState();
}

class _TelaTextoState extends State<TelaTexto> {
  final TextEditingController _controllerTexto = TextEditingController();
  Color aiWrittenColor = vermelho;
  String aiWritten = "AI Written";
  double aiWrittenDouble = 0;
  String infoText = "Info Text";

  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      appBar: NavBar(),
      body: ListView(
        children: [
          SizedBox(height: 80),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.text_fields, color: azulDestaque, size: 100),
              Text(
                "Verificar \n uso de IA em \n Texto",
                style: TextStyle(
                  color: azulDestaque,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 120),
          Column(
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
                    focusNode: _textFieldFocusNode,
                    minLines: 1,
                    maxLines: 20,
                    maxLength: 200,
                    controller: _controllerTexto,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      label: Text("Texto para verificar"),
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
            ],
          ),
          SizedBox(height: 20),
          Column(
            children: [
              SizedBox(
                width: 220,
                height: 45,
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
                      _textFieldFocusNode.unfocus();
                      if (_controllerTexto.text.isNotEmpty) {
                        final result = await verificarTexto(
                          _controllerTexto.text,
                        );

                        showPopupCard(
                          context: context,
                          builder: (context) {
                            return PopupCard(
                              elevation: 8,
                              color: fundo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(color: azulCinza, width: 6.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: SizedBox(
                                  width: 300,
                                  height: 400,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Resultados da Verificação:",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/Ai.svg",
                                            width: 50,
                                            color: aiWrittenColor,
                                          ),
                                          LinearPercentIndicator(
                                            width: 200.0,
                                            lineHeight: 20.0,
                                            percent: aiWrittenDouble,
                                            backgroundColor: azulCinza,
                                            progressColor: aiWrittenColor,
                                          ),

                                          Text(
                                            aiWritten.length == 1
                                                ? "0" + aiWritten
                                                : aiWritten,
                                            style: TextStyle(
                                              color: aiWrittenColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "%",
                                            style: TextStyle(
                                              color: aiWrittenColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Text(infoText),
                                      SizedBox(height: 20),
                                      Text(
                                        "Os resultados não são 100% precisos e devem ser usados como referência, não como confirmação definitiva.",
                                      ),
                                      SizedBox(height: 100),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButtonTheme(
                                            data: ElevatedButtonThemeData(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: azulDestaque,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            child: ElevatedButton(
                                              child: Text(
                                                "Fechar",
                                                style: TextStyle(
                                                  color: fundo,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
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
                          aiWritten = (result * 100).round().toString();
                          aiWrittenDouble = result;
                        });
                        infoText = await porcentagemTexto(
                          aiWrittenDouble * 100,
                        );
                        if (aiWrittenDouble > 0.4 && aiWrittenDouble < 0.75) {
                          setState(() {
                            aiWrittenColor = Colors.orange;
                          });
                        } else if (aiWrittenDouble <= 0.4) {
                          setState(() {
                            aiWrittenColor = Colors.green;
                          });
                        } else {
                          setState(() {
                            aiWrittenColor = vermelho;
                          });
                        }
                      }
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
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

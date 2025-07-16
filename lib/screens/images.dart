import 'package:flutter/material.dart';

import '../logic/imagedetector.dart';

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

// Importando o pacote de seleção de arquivos
// import 'package:file_picker/file_picker.dart';

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
  double aiGeneratedDouble = 0;
  double deepfakeDouble = 0;
  String infoText = "Info Text";
  Color deepfakeColor = vermelho;
  Color aiGeneratedColor = vermelho;

  final TextEditingController _controllerUrl = TextEditingController();

  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      appBar: NavBar(),
      body: ListView(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              /* CONTINUAR DESENVOLVENDO DEPOIS
              Text(
                "Verificar por URL",
                style: TextStyle(
                  color: _arquivo ? Colors.black : azulDestaque,
                  fontSize: 14,
                ),
              ),
              Switch(
                activeColor: azulDestaque,
                value: _arquivo,
                onChanged: (value) {
                  setState(() {
                    _arquivo = value;
                  });
                },
              ),
              Text(
                "Verificar por arquivo",
                style: TextStyle(
                  color: _arquivo ? azulDestaque : Colors.black,
                  fontSize: 14,
                ),
              ),*/
            ],
          ),
          SizedBox(height: 40),
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
          SizedBox(height: 120),
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
                          focusNode: _textFieldFocusNode,
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
                  ],
                ),
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
                      if (_controllerUrl.text.isNotEmpty) {
                        final result = await verificarImagem(
                          _controllerUrl.text,
                        );

                        if (result.toString() == "[Erro]") {
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
                                    width: 200,
                                    height: 300,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.error, color: vermelho),
                                            SizedBox(width: 10),
                                            Text(
                                              "Erro na Verificação:",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: vermelho,
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 20),
                                        Text(
                                          "Ocorreu um problema ao processar o link. Verifique se o endereço inserido é válido e tente novamente.",
                                        ),
                                        Text(
                                          "Talvez o link esteja incorreto ou a imagem esteja fora do ar.",
                                        ),
                                        SizedBox(height: 80),
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
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
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
                          );
                        } else if (result.toString() != ['Erro']) {
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
                                              "assets/images/Deepfake.svg",
                                              width: 50,
                                              color: deepfakeColor,
                                            ),
                                            LinearPercentIndicator(
                                              width: 200.0,
                                              lineHeight: 20.0,
                                              percent: deepfakeDouble,
                                              backgroundColor: azulCinza,
                                              progressColor: deepfakeColor,
                                            ),
                                            Text(
                                              deepfake.length == 1
                                                  ? "0" + deepfake
                                                  : deepfake,
                                              style: TextStyle(
                                                color: deepfakeColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "%",
                                              style: TextStyle(
                                                color: deepfakeColor,
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
                                              "assets/images/Ai.svg",
                                              width: 50,
                                              color: aiGeneratedColor,
                                            ),
                                            LinearPercentIndicator(
                                              width: 200.0,
                                              lineHeight: 20.0,
                                              percent: aiGeneratedDouble,
                                              backgroundColor: azulCinza,
                                              progressColor: aiGeneratedColor,
                                            ),

                                            Text(
                                              aiGenerated.length == 1
                                                  ? "0" + aiGenerated
                                                  : aiGenerated,
                                              style: TextStyle(
                                                color: aiGeneratedColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "%",
                                              style: TextStyle(
                                                color: aiGeneratedColor,
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
                                        SizedBox(height: 30),
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
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
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
                            aiGenerated =
                                double.parse(result[0])
                                    .round()
                                    .toString(); //Converter para double aqui depois
                            deepfake =
                                double.parse(result[1]).round().toString();
                            aiGeneratedDouble = double.parse(result[0]) / 100;
                            deepfakeDouble = double.parse(result[1]) / 100;
                          });
                          infoText = await compararPorcentagens(
                            (aiGeneratedDouble * 100),
                            (deepfakeDouble * 100),
                          );
                          if (deepfakeDouble > 0.4 && deepfakeDouble < 0.75) {
                            setState(() {
                              deepfakeColor = Colors.orange;
                            });
                          } else if (deepfakeDouble <= 0.4) {
                            setState(() {
                              deepfakeColor = Colors.green;
                            });
                          } else {
                            setState(() {
                              deepfakeColor = vermelho;
                            });
                          }

                          if (aiGeneratedDouble > 0.4 &&
                              aiGeneratedDouble < 0.75) {
                            setState(() {
                              aiGeneratedColor = Colors.orange;
                            });
                          } else if (aiGeneratedDouble <= 0.4) {
                            setState(() {
                              aiGeneratedColor = Colors.green;
                            });
                          } else {
                            setState(() {
                              aiGeneratedColor = vermelho;
                            });
                          }
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

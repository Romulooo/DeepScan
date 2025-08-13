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
import 'package:file_picker/file_picker.dart';

//fudeu
import 'package:permission_handler/permission_handler.dart';

// Loader
import 'package:loader_overlay/loader_overlay.dart';

//Camera
import 'package:camera/camera.dart';

//Converter arquivos XFile
import 'dart:typed_data';

//late List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //_cameras = await availableCameras();
  runApp(const TelaImagem());
}

class TelaImagem extends StatefulWidget {
  const TelaImagem({super.key});

  @override
  State<TelaImagem> createState() => _TelaImagemState();
}

class _TelaImagemState extends State<TelaImagem> {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  int tipoVerifica = 0; // 0 = URL, 1 = Arquivo, 2 = Câmera
  String aiGenerated = "AI Generated";
  String deepfake = "Deepfake";
  double aiGeneratedDouble = 0;
  double deepfakeDouble = 0;
  String infoText = "Info Text";
  Color deepfakeColor = vermelho;
  Color aiGeneratedColor = vermelho;

  final TextEditingController _controllerUrl = TextEditingController();

  final FocusNode _textFieldFocusNode = FocusNode();

  PlatformFile? _selectedFile;
  PlatformFile? fotoFile;

  Future<void> _selecionarArquivo() async {
    //Permissão

    await [Permission.storage, Permission.photos].request();

    FilePickerResult? resultado = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
      withData: true,
    );

    if (resultado != null && resultado.files.isNotEmpty) {
      setState(() {
        _selectedFile = resultado.files.first;
      });
    } else {
      // O usuário cancelou a seleção
      setState(() {
        _selectedFile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: ToggleButtons(
        isSelected: [tipoVerifica == 0, tipoVerifica == 1, tipoVerifica == 2],
        selectedColor: azulDestaque,
        selectedBorderColor: azulCinza,
        focusColor: azulDestaque,
        highlightColor: azulCinza,
        fillColor: azulCinza,
        splashColor: const Color.fromARGB(30, 31, 12, 67),
        onPressed: (index) {
          setState(() {
            tipoVerifica = index;
          });
        },
        children: [
          Icon(Icons.link),
          Icon(Icons.file_copy),
          Icon(Icons.camera_alt),
        ],
      ),

      backgroundColor: fundo,
      appBar: NavBar(),
      body: ListView(
        children: [
          SizedBox(height: 80),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tipoVerifica != 2
                  ? Icon(
                    tipoVerifica == 0
                        ? Icons.link
                        : (tipoVerifica == 1
                            ? Icons.file_copy
                            : Icons.camera_alt),
                    color: azulDestaque,
                    size: 100,
                  )
                  : SizedBox(),

              tipoVerifica != 2
                  ? Text(
                    "Verificar \n imagem por \n ${tipoVerifica == 0 ? "URL" : (tipoVerifica == 1 ? "Arquivo" : "Câmera")}",
                    style: TextStyle(
                      color: azulDestaque,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                  : SizedBox(),
            ],
          ),

          tipoVerifica == 1
              ? Column(
                children: [
                  SizedBox(height: 100),
                  ElevatedButtonTheme(
                    data: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () => _selecionarArquivo(),
                      child: const Text(
                        'Escolher Arquivo',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  if (_selectedFile != null)
                    SizedBox(
                      width: 300,
                      child: Text(
                        'Arquivo selecionado: ${_selectedFile!.name}',

                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  else
                    const Text(
                      'Nenhum arquivo selecionado',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                ],
              )
              : (tipoVerifica == 0
                  ? Center(
                    child: Column(
                      children: [
                        SizedBox(height: 119),
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
                  )
                  : _buildUI()),
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
                      context.loaderOverlay.show();
                      late final result;
                      _textFieldFocusNode.unfocus();
                      if (_controllerUrl.text.isNotEmpty && tipoVerifica == 0) {
                        result = await verificarImagemURL(_controllerUrl.text);
                      } else if (_selectedFile != null && tipoVerifica == 1) {
                        result = await verificarImagemArquivo(_selectedFile!);
                      } else if (tipoVerifica == 2) {
                        result = await verificarImagemArquivo(fotoFile!);
                      } else {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Insira uma imagem para verificar."),
                            duration: Duration(seconds: 2),
                            dismissDirection: DismissDirection.down,
                          ),
                        );
                        //result = ["Erro"];
                      }
                      context.loaderOverlay.hide();
                      if (result.toString() == "[Erro]") {
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
                                        "Ocorreu um problema ao processar o link ou imagem. Verifique se o endereço inserido é válido e tente novamente.",
                                      ),
                                      Text(
                                        "Talvez o link esteja incorreto ou a imagem esteja fora do ar.",
                                      ),
                                      SizedBox(height: 60),
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
                                            animation: true,
                                            animationDuration: 750,
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
                                            animation: true,
                                            animationDuration: 750,
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
                          aiGenerated =
                              double.parse(result[0]).round().toString();
                          deepfake = double.parse(result[1]).round().toString();
                          aiGeneratedDouble = double.parse(result[0]) / 100;
                          deepfakeDouble = double.parse(result[1]) / 100;
                        });
                        infoText = await compararPorcentagens(
                          (aiGeneratedDouble * 100),
                          (deepfakeDouble * 100),
                        );
                        if (deepfakeDouble <= 0.25) {
                          setState(() {
                            deepfakeColor = Colors.green;
                          });
                        } else if (deepfakeDouble > 0.25 &&
                            deepfakeDouble <= 0.50) {
                          setState(() {
                            deepfakeColor = const Color.fromARGB(
                              255,
                              215,
                              187,
                              45,
                            );
                          });
                        } else if (deepfakeDouble > 0.50 &&
                            deepfakeDouble <= 0.75) {
                          setState(() {
                            deepfakeColor = Colors.orange;
                          });
                        } else {
                          setState(() {
                            deepfakeColor = vermelho;
                          });
                        }
                        if (aiGeneratedDouble <= 0.25) {
                          setState(() {
                            aiGeneratedColor = Colors.green;
                          });
                        } else if (aiGeneratedDouble > 0.25 &&
                            aiGeneratedDouble <= 0.50) {
                          setState(() {
                            aiGeneratedColor = const Color.fromARGB(
                              255,
                              215,
                              187,
                              45,
                            );
                          });
                        } else if (aiGeneratedDouble > 0.50 &&
                            aiGeneratedDouble <= 0.75) {
                          setState(() {
                            aiGeneratedColor = Colors.orange;
                          });
                        } else {
                          setState(() {
                            aiGeneratedColor = vermelho;
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

              SizedBox(height: 50),
            ],
          ),
        ],
      ),

      bottomNavigationBar: BottomBar(),
    );
  }

  Widget _buildUI() {
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CameraPreview(cameraController!),
                  SizedBox(width: 20),
                  fotoFile != null && fotoFile!.bytes != null
                      ? Image.memory(
                        fotoFile!.bytes!,
                        fit: BoxFit.cover,
                        height: 250,
                      )
                      : SizedBox(),
                ],
              ),
            ),
            SizedBox(height: 20),
            IconButton(
              color: Colors.blueGrey,
              onPressed: () async {
                XFile foto = await cameraController!.takePicture();

                // Lê os bytes da foto
                Uint8List bytes = await foto.readAsBytes();

                // Constrói um PlatformFile
                setState(() {
                  fotoFile = PlatformFile(
                    name: foto.name,
                    size: bytes.length,
                    bytes: bytes,
                    path: foto.path,
                  );
                });
              },
              icon: Icon(Icons.camera),
              iconSize: 40,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setupCameraController() async {
    List<CameraDescription> _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      setState(() {
        cameras = _cameras;
        cameraController = CameraController(
          _cameras.first,
          ResolutionPreset.high,
        );
      });
      cameraController?.initialize().then((_) {
        setState(() {});
      });
    }
  }
}

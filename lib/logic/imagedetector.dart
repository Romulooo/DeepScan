import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';

import 'package:crypto/crypto.dart';

// Aqui vai a chave e o usuário da API Sightengine
String key = "<key>";
String user = "<user>";
String urlapi = 'http://10.0.31.101:5000';

Future<List<String>> verificarImagemURL(String imagemUrl) async {
  final normalized = imagemUrl.trim();
  final hashStr = md5.convert(utf8.encode(normalized)).toString();

  try {
    final uriConsulta = Uri.parse('$urlapi/consultarimagem/$hashStr');
    final resConsulta = await http.get(uriConsulta);

    if (resConsulta.statusCode == 200) {
      final data = jsonDecode(resConsulta.body);
      if (data is Map &&
          data['encontrado'] == true &&
          data.containsKey('ai') &&
          data.containsKey('deep')) {
        return [data['ai'].toString(), data['deep'].toString()];
      }
    }
  } catch (_) {
    print("Erro");
  }

  String ia;
  String deepfake;

  final uriGenAI = Uri.https('api.sightengine.com', '/1.0/check.json', {
    'url': normalized,
    'models': 'genai',
    'api_user': user,
    'api_secret': key,
  });

  try {
    final resGen = await http.get(uriGenAI);
    if (resGen.statusCode != 200) return ['Erro'];
    final output = jsonDecode(resGen.body);
    if (output['status'] == 'failure') return ['Erro'];
    ia = ((output['type']?['ai_generated'] ?? 0) * 100).toString();
  } catch (_) {
    return ['Erro'];
  }

  final uriDeep = Uri.https('api.sightengine.com', '/1.0/check.json', {
    'url': normalized,
    'models': 'deepfake',
    'api_user': user,
    'api_secret': key,
  });

  try {
    final resDeep = await http.get(uriDeep);
    if (resDeep.statusCode != 200) return ['Erro'];
    final output = jsonDecode(resDeep.body);
    if (output['status'] == 'failure') return ['Erro'];
    deepfake = ((output['type']?['deepfake'] ?? 0) * 100).toString();
  } catch (_) {
    return ['Erro'];
  }

  try {
    final uriAdd = Uri.parse('$urlapi/adicionarimagem');
    await http.post(
      uriAdd,
      headers: {'content-type': 'application/json'},
      body: jsonEncode({"hash": hashStr, "ia": ia, "deep": deepfake}),
    );
  } catch (_) {}

  return [ia, deepfake];
}

Future<List<String>> verificarImagemArquivo(PlatformFile imagem) async {
  if (imagem.bytes == null) return ['Erro'];

  String ia;
  String deepfake;
  final uri = Uri.parse('https://api.sightengine.com/1.0/check.json');

  final reqGen =
      http.MultipartRequest('POST', uri)
        ..fields['models'] = 'genai'
        ..fields['api_user'] = user
        ..fields['api_secret'] = key
        ..files.add(
          http.MultipartFile.fromBytes(
            'media',
            imagem.bytes!,
            filename: imagem.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        );

  final resGen = await reqGen.send();
  if (resGen.statusCode != 200) return ['Erro'];
  final bodyGen = await resGen.stream.bytesToString();
  final outGen = json.decode(bodyGen);
  if (outGen['status'] == 'failure') return ['Erro'];
  ia = ((outGen['type']?['ai_generated'] ?? 0) * 100).toString();

  final reqDeep =
      http.MultipartRequest('POST', uri)
        ..fields['models'] = 'deepfake'
        ..fields['api_user'] = user
        ..fields['api_secret'] = key
        ..files.add(
          http.MultipartFile.fromBytes(
            'media',
            imagem.bytes!,
            filename: imagem.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        );

  final resDeep = await reqDeep.send();
  if (resDeep.statusCode != 200) return ['Erro'];
  final bodyDeep = await resDeep.stream.bytesToString();
  final outDeep = json.decode(bodyDeep);
  if (outDeep['status'] == 'failure') return ['Erro'];
  deepfake = ((outDeep['type']?['deepfake'] ?? 0) * 100).toString();

  return [ia, deepfake];
}

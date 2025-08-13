import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';

import 'package:crypto/crypto.dart';

// Aqui vai a chave e o usuário da API Sightengine
String key = "DJtqiybxU42bZpVtrY6yvTQENAAnVZTx";
String user = "1339326965";

Future<List> verificarImagemURL(imagem) async {
  /*final hash = md5.convert(utf8.encode(imagem));
  String hashStr = hash.toString();
  
  try {
    final url = Uri.parse('http://10.0.31.101:5000/consultarimagem/$hashStr');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is Map &&
          data.containsKey('encontrado') &&
          data['encontrado'] == false) {
        print('Imagem não encontrada.');
      } else {
        print('Resultado encontrado: $data');
        return ([data['ai'], data['deep']]);
      }
    } else {
      print('Erro na requisição. Código HTTP: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro ao consultar imagem: $e');
  }*/

  //Faz a requisição para a api

  String deepfake;
  String ia;

  final url1 = Uri.https('api.sightengine.com', '/1.0/check.json', {
    'url': imagem,
    'models': 'genai',
    'api_user': user,
    'api_secret': key,
  });

  try {
    final response = await http.get(url1);

    if (response.statusCode == 200) {
      final output = jsonDecode(response.body);
      if (output["status"] == "failure") {
        return ['Erro'];
      }

      ia = (output['type']['ai_generated'] * 100).toString();
    } else {
      return ['Erro'];
    }
  } catch (e) {
    return ['Erro'];
  }

  final url2 = Uri.https('api.sightengine.com', '/1.0/check.json', {
    'url': imagem,
    'models': 'deepfake',
    'api_user': user,
    'api_secret': key,
  });

  try {
    final response = await http.get(url2);

    if (response.statusCode == 200) {
      final output = jsonDecode(response.body);
      if (output["status"] == "failure") {
        return ['Erro'];
      }
      deepfake = (output['type']['deepfake'] * 100).toString();
    } else {
      return ['Erro'];
    }
  } catch (e) {
    return ['Erro'];
  }

  //Antes de retornar adiciona no banco de dados
  /*
  final url = Uri.parse('http://127.0.0.1:5000/adicionarimagem');
  final response = await http.post(
    url,
    headers: {'content-type': 'application/json'},
    body: jsonEncode({"hash": hashStr, "ia": ia, "deep": deepfake}),
  );
*/
  return ([ia, deepfake]);
}

Future<List> verificarImagemArquivo(PlatformFile imagem) async {
  String deepfake;
  String ia;

  final uri1 = Uri.parse('https://api.sightengine.com/1.0/check.json');

  if (imagem.bytes == null) {
    return ['Erro'];
  }
  final request1 =
      http.MultipartRequest('POST', uri1)
        ..fields['models'] = 'genai'
        ..fields['api_user'] = user
        ..fields['api_secret'] = key
        ..files.add(
          http.MultipartFile.fromBytes(
            'media',
            imagem.bytes!,
            filename: imagem.name,
            contentType: MediaType('image', 'jpg'),
          ),
        );
  final responseIA = await request1.send();

  if (responseIA.statusCode == 200) {
    final responseData1 = await responseIA.stream.bytesToString();
    final output1 = json.decode(responseData1);

    ia = (output1['type']['ai_generated'] * 100).toString();
  } else {
    return ['Erro'];
  }

  final request2 =
      http.MultipartRequest('POST', uri1)
        ..fields['models'] = 'deepfake'
        ..fields['api_user'] = user
        ..fields['api_secret'] = key
        ..files.add(
          http.MultipartFile.fromBytes(
            'media',
            imagem.bytes!,
            filename: imagem.name,
            contentType: MediaType('image', 'jpg'),
          ),
        );
  final responseDeepFake = await request2.send();

  if (responseDeepFake.statusCode == 200) {
    final responseData2 = await responseDeepFake.stream.bytesToString();
    final output2 = json.decode(responseData2);

    deepfake = (output2['type']['deepfake'] * 100).toString();
  } else {
    return ['Erro'];
  }

  return ([ia, deepfake]);
}

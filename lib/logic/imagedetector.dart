import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';

Future<List> verificarImagemURL(imagem) async {
  String deepfake;
  String ia;
  //return (["99.0001", "67.99999"]);

  final url1 = Uri.https('api.sightengine.com', '/1.0/check.json', {
    'url': imagem,
    'models': 'genai',
    'api_user': '<user>',
    'api_secret': '<key>',
  });

  try {
    final response = await http.get(url1);

    if (response.statusCode == 200) {
      final output = jsonDecode(response.body);
      if (output["status"] == "failure") {
        return ['Erro'];
      }
      print(output);
      ia = (output['type']['ai_generated'] * 100).toString();
    } else {
      print('Erro: ${response.statusCode}');
      print(response.body);
      return ['Erro'];
    }
  } catch (e) {
    print('Erro na requisição: $e');
    return ['Erro'];
  }

  final url2 = Uri.https('api.sightengine.com', '/1.0/check.json', {
    'url': imagem,
    'models': 'deepfake',
    'api_user': '<user>',
    'api_secret': '<key>',
  });

  try {
    final response = await http.get(url2);

    if (response.statusCode == 200) {
      final output = jsonDecode(response.body);
      if (output["status"] == "failure") {
        return ['Erro'];
      }
      print("-------------------------------");
      print(output["status"]);
      deepfake = (output['type']['deepfake'] * 100).toString();
    } else {
      print('Erro: ${response.statusCode}');
      print(response.body);
      return ['Erro'];
    }
  } catch (e) {
    print('Erro na requisição: $e');
    return ['Erro'];
  }

  print("IA: " + ia + "     DeepFake: " + deepfake);
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
        ..fields['api_user'] = '<user>'
        ..fields['api_secret'] = '<key>'
        ..files.add(
          http.MultipartFile.fromBytes(
            'media',
            imagem.bytes!,
            filename: imagem.name,
            contentType: MediaType('image', 'jpg'),
          ),
        );
  final response1 = await request1.send();

  if (response1.statusCode == 200) {
    final responseData1 = await response1.stream.bytesToString();
    final output1 = json.decode(responseData1);
    print(output1);
    ia = (output1['type']['ai_generated'] * 100).toString();
  } else {
    return ['Erro'];
  }

  final request2 =
      http.MultipartRequest('POST', uri1)
        ..fields['models'] = 'deepfake'
        ..fields['api_user'] = '<user>'
        ..fields['api_secret'] = '<key>'
        ..files.add(
          http.MultipartFile.fromBytes(
            'media',
            imagem.bytes!,
            filename: imagem.name,
            contentType: MediaType('image', 'jpg'),
          ),
        );
  final response2 = await request2.send();

  if (response2.statusCode == 200) {
    final responseData2 = await response2.stream.bytesToString();
    final output2 = json.decode(responseData2);
    print(output2);
    deepfake = (output2['type']['deepfake'] * 100).toString();
  } else {
    return ['Erro'];
  }
  print(ia + " " + deepfake);
  return ([ia, deepfake]);
}

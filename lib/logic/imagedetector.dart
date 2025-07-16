import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List> verificarImagem(imagem) async {
  String deepfake;
  String ia;
  //return (["99.0001", "67.99999"]);

  final url1 = Uri.https('api.sightengine.com', '/1.0/check.json', {
    'url': imagem,
    'models': 'genai',
    'api_user': '77467266',
    'api_secret': 'xyq2G35dvnwEBm3RHZjjtLjGCKbbX5uf',
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
    'api_user': '77467266',
    'api_secret': 'xyq2G35dvnwEBm3RHZjjtLjGCKbbX5uf',
  });

  try {
    final response = await http.get(url2);

    if (response.statusCode == 200) {
      final output = jsonDecode(response.body);
      if (output["status"] == "failure") {
        return ['Erro'];
      }

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

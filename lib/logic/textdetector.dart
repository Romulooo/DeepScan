import 'dart:convert';
import 'package:http/http.dart' as http;

import './keys.dart';

// Aqui vai a chave da API Sapling's API
String key = textKey;

Future<double> verificarTexto(texto) async {
  final url = Uri.parse('https://api.sapling.ai/api/v1/aidetect');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'key': key, 'text': texto}),
  );

  if (response.statusCode >= 200 && response.statusCode < 300) {
    final data = jsonDecode(response.body);
    return data['score'];
  } else {
    print('Error: ${response.statusCode}');
  }

  return 0;
}

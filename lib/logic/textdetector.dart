import 'dart:convert';
import 'package:http/http.dart' as http;

// Aqui vai a chave da API Sapling's API
String key = "0MPZ3GUM2XLKAKQW04QCOJ22YLQ2L9OF";

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

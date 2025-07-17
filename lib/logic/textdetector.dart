import 'dart:convert';
//import 'dart:ffi';
import 'package:http/http.dart' as http;

Future<double> verificarTexto(texto) async {
  //return 0.99 * 100;
  final url = Uri.parse('https://api.sapling.ai/api/v1/aidetect');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'key': 'H6LPTMDFMS9KH2NBBYXL8PAL1TDJM5AK',
      'text': texto,
    }),
  );

  if (response.statusCode >= 200 && response.statusCode < 300) {
    final data = jsonDecode(response.body);
    return data['token_probs'][0];
  } else {
    print('Error: ${response.statusCode}');
  }

  return 0;
}

// arquivo: lib/funcionalidades/api/categorias_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoriasApi {
  static const String _baseUrl = "http://10.0.2.2:8080/categorias";

  static Future<List<dynamic>> listar() async {
    final resp = await http.get(Uri.parse(_baseUrl));

    if (resp.statusCode != 200) {
      throw Exception("Erro ao listar categorias: ${resp.body}");
    }

    return jsonDecode(resp.body);
  }

  static Future<Map<String, dynamic>> criar(String nome) async {
    final resp = await http.post(
      Uri.parse(_baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nome": nome}),
    );

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception("Erro ao criar categoria: ${resp.body}");
    }

    return jsonDecode(resp.body);
  }
}
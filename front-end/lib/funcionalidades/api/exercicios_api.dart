import 'dart:convert';
import 'package:http/http.dart' as http;

class ExerciciosApi {
  static const String _baseUrl = "http://10.0.2.2:8080/exercicios";

  static Future<List<dynamic>> listar() async {
    try {
      print('🔵 Fazendo requisição para: $_baseUrl');
      
      final resp = await http.get(
        Uri.parse(_baseUrl),
        headers: {"Content-Type": "application/json"},
      );

      print('🔵 Status Code: ${resp.statusCode}');
      print('🔵 Response Body: ${resp.body}');

      if (resp.statusCode != 200) {
        throw Exception("Erro ao listar exercícios: ${resp.statusCode}");
      }

      final List<dynamic> lista = jsonDecode(resp.body);
      print('🔵 Quantidade de exercícios: ${lista.length}');
      
      return lista;
    } catch (e) {
      print('🔴 ERRO NA API: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> criarExercicio({
    required String nome,
    required String imagem,
    required String tipoEquipamento,
    String? linkYoutube,
    required List<String> categoriasIds,
  }) async {
    final url = Uri.parse(_baseUrl);

    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nome": nome,
        "imagem": imagem,
        "tipoEquipamento": tipoEquipamento.toUpperCase(),
        "linkYoutube": linkYoutube,
        "categoriasIds": categoriasIds,
      }),
    );

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception("Erro ao criar exercício: ${resp.body}");
    }

    return jsonDecode(resp.body);
  }

  static Future<Map<String, dynamic>> buscar(String id) async {
    final url = Uri.parse("$_baseUrl/$id");
    final resp = await http.get(url);

    if (resp.statusCode != 200) {
      throw Exception("Erro ao buscar exercício: ${resp.body}");
    }

    return jsonDecode(resp.body);
  }

  static Future<Map<String, dynamic>> atualizar({
    required String id,
    required String nome,
    required String imagem,
    required String tipoEquipamento,
    String? linkYoutube,
    required List<String> categoriasIds,
  }) async {
    final url = Uri.parse("$_baseUrl/$id");

    final resp = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nome": nome,
        "imagem": imagem,
        "tipoEquipamento": tipoEquipamento.toUpperCase(),
        "linkYoutube": linkYoutube,
        "categoriasIds": categoriasIds,
      }),
    );

    if (resp.statusCode != 200) {
      throw Exception("Erro ao atualizar exercício: ${resp.body}");
    }

    return jsonDecode(resp.body);
  }

  static Future<void> deletar(String id) async {
    final url = Uri.parse("$_baseUrl/$id");
    final resp = await http.delete(url);

    if (resp.statusCode != 200 && resp.statusCode != 204) {
      throw Exception("Erro ao deletar exercício: ${resp.body}");
    }
  }
}
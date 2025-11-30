import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../treino/dominio/entidades/treino.dart';

class TreinoApi {
  static const String _baseUrl = "http://10.0.2.2:8080/treinos";

  // Método helper para obter o token
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Método helper para criar headers com token
  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<List<Treino>> listarPorUsuario(String usuarioId) async {
    final url = Uri.parse("$_baseUrl/usuario/$usuarioId");
    final headers = await _getHeaders();
    final resp = await http.get(url, headers: headers);

    if (resp.statusCode != 200) {
      throw Exception("Erro ao carregar treinos por usuário: ${resp.body}");
    }

    final lista = jsonDecode(resp.body) as List<dynamic>;
    return lista.map((t) => Treino.fromJson(t as Map<String, dynamic>)).toList();
  }

  static Future<List<Treino>> listarPorNivel(String nivel) async {
    final url = Uri.parse("$_baseUrl/nivel/$nivel");
    final headers = await _getHeaders();
    
    print("=== REQUISIÇÃO TREINOS ===");
    print("URL: $url");
    print("Headers: $headers");
    
    final resp = await http.get(url, headers: headers);

    print("Status: ${resp.statusCode}");
    print("Body: ${resp.body}");
    print("=========================");

    if (resp.statusCode != 200) {
      throw Exception("Erro ao carregar treinos por nível: ${resp.body}");
    }

    final lista = jsonDecode(resp.body) as List<dynamic>;
    return lista.map((t) => Treino.fromJson(t as Map<String, dynamic>)).toList();
  }

  static Future<Treino> buscar(String id) async {
    final url = Uri.parse("$_baseUrl/$id");
    final headers = await _getHeaders();
    final resp = await http.get(url, headers: headers);

    if (resp.statusCode != 200) {
      throw Exception("Erro ao buscar treino: ${resp.body}");
    }

    return Treino.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  static Future<Treino> criar({
    required String titulo,
    required bool botaoEscuro,
    String? linkYoutube,
    required List<String> exerciciosIds,
    required String usuarioId,
  }) async {
    final headers = await _getHeaders();
    final resp = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode({
        "titulo": titulo,
        "botaoEscuro": botaoEscuro,
        "linkYoutube": linkYoutube,
        "exerciciosIds": exerciciosIds,
        "usuarioId": usuarioId,
      }),
    );

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception("Erro ao criar treino: ${resp.body}");
    }

    return Treino.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  static Future<Treino> atualizar({
    required String id,
    required String titulo,
    required bool botaoEscuro,
    String? linkYoutube,
    required List<String> exerciciosIds,
  }) async {
    final headers = await _getHeaders();
    final resp = await http.put(
      Uri.parse("$_baseUrl/$id"),
      headers: headers,
      body: jsonEncode({
        "titulo": titulo,
        "botaoEscuro": botaoEscuro,
        "linkYoutube": linkYoutube,
        "exerciciosIds": exerciciosIds,
      }),
    );

    if (resp.statusCode != 200) {
      throw Exception("Erro ao atualizar treino: ${resp.body}");
    }

    return Treino.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  static Future<void> deletar(String id) async {
    final headers = await _getHeaders();
    final resp = await http.delete(Uri.parse("$_baseUrl/$id"), headers: headers);

    if (resp.statusCode != 200) {
      throw Exception("Erro ao deletar treino: ${resp.body}");
    }
  }
}
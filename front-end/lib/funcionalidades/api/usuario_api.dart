import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../usuario/dominio/entidades/usuario.dart';

class UsuarioApi {
  static const String _baseUrl = "http://10.0.2.2:8080/usuarios";
  static const String _authUrl = "http://10.0.2.2:8080/auth";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    final url = Uri.parse("$_authUrl/login");
    
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "senha": senha,
      }),
    );

    if (resp.statusCode != 200) {
      final error = jsonDecode(resp.body);
      throw Exception(error['message'] ?? "Erro ao fazer login");
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final token = data['access_token'] as String;
    
    await _saveToken(token);
    
    return data;
  }

  static Future<void> logout() async {
    await _removeToken();
  }

  static Future<Usuario> criar({
    required String nome,
    required String email,
    required String senha,
    String? fotoBase64,
    String? nivel,
  }) async {
    final url = Uri.parse(_baseUrl);
    
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "nome": nome,
        "email": email,
        "senha": senha,
        if (fotoBase64 != null) "fotoBase64": fotoBase64,
        if (nivel != null) "nivel": nivel,
      }),
    );

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception("Erro ao criar usuário: ${resp.body}");
    }

    return Usuario.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  static Future<List<Usuario>> listar() async {
    final url = Uri.parse(_baseUrl);
    final headers = await _getHeaders();
    
    final resp = await http.get(url, headers: headers);

    if (resp.statusCode != 200) {
      throw Exception("Erro ao listar usuários: ${resp.body}");
    }

    final lista = jsonDecode(resp.body) as List<dynamic>;
    return lista.map((u) => Usuario.fromJson(u as Map<String, dynamic>)).toList();
  }

  static Future<Usuario> buscar(String id) async {
    final url = Uri.parse("$_baseUrl/$id");
    final headers = await _getHeaders();
    
    final resp = await http.get(url, headers: headers);

    if (resp.statusCode != 200) {
      throw Exception("Erro ao buscar usuário: ${resp.body}");
    }

    return Usuario.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  static Future<Usuario> getMe() async {
    final url = Uri.parse("$_baseUrl/me");
    final headers = await _getHeaders();
    
    final resp = await http.get(url, headers: headers);

    if (resp.statusCode != 200) {
      throw Exception("Erro ao obter usuário: ${resp.body}");
    }

    return Usuario.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  static Future<Usuario> atualizarMe({
    String? nome,
    String? email,
    String? senha,
    String? fotoBase64,
    String? nivel,
  }) async {
    final url = Uri.parse("$_baseUrl/me");
    final headers = await _getHeaders();
    
    final body = <String, dynamic>{};
    if (nome != null) body['nome'] = nome;
    if (email != null) body['email'] = email;
    if (senha != null) body['senha'] = senha;
    if (fotoBase64 != null) body['fotoBase64'] = fotoBase64;
    if (nivel != null) body['nivel'] = nivel;
    
    final resp = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (resp.statusCode != 200) {
      throw Exception("Erro ao atualizar usuário: ${resp.body}");
    }

    return Usuario.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  static Future<Usuario> atualizar({
    required String id,
    String? nome,
    String? email,
    String? senha,
    String? fotoBase64,
    String? nivel,
  }) async {
    final url = Uri.parse("$_baseUrl/$id");
    final headers = await _getHeaders();
    
    final body = <String, dynamic>{};
    if (nome != null) body['nome'] = nome;
    if (email != null) body['email'] = email;
    if (senha != null) body['senha'] = senha;
    if (fotoBase64 != null) body['fotoBase64'] = fotoBase64;
    if (nivel != null) body['nivel'] = nivel;
    
    final resp = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (resp.statusCode != 200) {
      throw Exception("Erro ao atualizar usuário: ${resp.body}");
    }

    return Usuario.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  static Future<void> deletar(String id) async {
    final url = Uri.parse("$_baseUrl/$id");
    final headers = await _getHeaders();
    
    final resp = await http.delete(url, headers: headers);

    if (resp.statusCode != 200 && resp.statusCode != 204) {
      throw Exception("Erro ao deletar usuário: ${resp.body}");
    }
  }

  static Future<bool> estaAutenticado() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<String?> getToken() async {
    return await _getToken();
  }
}
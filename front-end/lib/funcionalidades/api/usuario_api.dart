import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../usuario/dominio/entidades/usuario.dart';

class UsuarioApi {
  static const String _baseUrl = "http://10.0.2.2:8080/usuarios";
  static const String _authUrl = "http://10.0.2.2:8080/auth";

  // =============================
  // HELPERS PARA TOKEN
  // =============================

  /// Obtém o token salvo no SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Salva o token no SharedPreferences
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  /// Remove o token do SharedPreferences
  static Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  /// Cria headers com token de autenticação
  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // =============================
  // AUTENTICAÇÃO
  // =============================

  /// Faz login e retorna o token de acesso
  static Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    final url = Uri.parse("$_authUrl/login");
    
    print("=== LOGIN ===");
    print("URL: $url");
    print("Email: $email");
    
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "senha": senha,
      }),
    );

    print("Status: ${resp.statusCode}");
    print("Body: ${resp.body}");
    print("=============");

    if (resp.statusCode != 200) {
      final error = jsonDecode(resp.body);
      throw Exception(error['message'] ?? "Erro ao fazer login");
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final token = data['access_token'] as String;
    
    // Salva o token
    await _saveToken(token);
    
    print("✅ Token salvo com sucesso!");
    
    return data;
  }

  /// Faz logout (remove o token)
  static Future<void> logout() async {
    await _removeToken();
    print("✅ Logout realizado!");
  }

  // =============================
  // CRUD DE USUÁRIO
  // =============================

  /// Cria um novo usuário (registro)
  static Future<Usuario> criar({
    required String nome,
    required String email,
    required String senha,
    String? fotoBase64,
    String? nivel,
  }) async {
    final url = Uri.parse(_baseUrl);
    
    print("=== CRIAR USUÁRIO ===");
    print("URL: $url");
    print("Nome: $nome");
    print("Email: $email");
    
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

    print("Status: ${resp.statusCode}");
    print("Body: ${resp.body}");
    print("====================");

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception("Erro ao criar usuário: ${resp.body}");
    }

    return Usuario.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  /// Busca todos os usuários (requer autenticação)
  static Future<List<Usuario>> listar() async {
    final url = Uri.parse(_baseUrl);
    final headers = await _getHeaders();
    
    print("=== LISTAR USUÁRIOS ===");
    print("URL: $url");
    print("Headers: $headers");
    
    final resp = await http.get(url, headers: headers);

    print("Status: ${resp.statusCode}");
    print("Body: ${resp.body}");
    print("=======================");

    if (resp.statusCode != 200) {
      throw Exception("Erro ao listar usuários: ${resp.body}");
    }

    final lista = jsonDecode(resp.body) as List<dynamic>;
    return lista.map((u) => Usuario.fromJson(u as Map<String, dynamic>)).toList();
  }

  /// Busca um usuário específico pelo ID
  static Future<Usuario> buscar(String id) async {
    final url = Uri.parse("$_baseUrl/$id");
    final headers = await _getHeaders();
    
    print("=== BUSCAR USUÁRIO ===");
    print("URL: $url");
    
    final resp = await http.get(url, headers: headers);

    print("Status: ${resp.statusCode}");
    print("Body: ${resp.body}");
    print("======================");

    if (resp.statusCode != 200) {
      throw Exception("Erro ao buscar usuário: ${resp.body}");
    }

    return Usuario.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  /// Busca os dados do usuário autenticado
  static Future<Usuario> getMe() async {
    final url = Uri.parse("$_baseUrl/me");
    final headers = await _getHeaders();
    
    print("=== GET ME ===");
    print("URL: $url");
    print("Headers: $headers");
    
    final resp = await http.get(url, headers: headers);

    print("Status: ${resp.statusCode}");
    print("Body: ${resp.body}");
    print("==============");

    if (resp.statusCode != 200) {
      throw Exception("Erro ao obter usuário: ${resp.body}");
    }

    return Usuario.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  /// Atualiza os dados do usuário autenticado (PATCH parcial)
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
    
    print("=== ATUALIZAR ME ===");
    print("URL: $url");
    print("Body: $body");
    
    final resp = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    print("Status: ${resp.statusCode}");
    print("Body: ${resp.body}");
    print("====================");

    if (resp.statusCode != 200) {
      throw Exception("Erro ao atualizar usuário: ${resp.body}");
    }

    return Usuario.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  /// Atualiza um usuário específico pelo ID (requer permissão)
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
    
    print("=== ATUALIZAR USUÁRIO ===");
    print("URL: $url");
    print("Body: $body");
    
    final resp = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    print("Status: ${resp.statusCode}");
    print("Body: ${resp.body}");
    print("=========================");

    if (resp.statusCode != 200) {
      throw Exception("Erro ao atualizar usuário: ${resp.body}");
    }

    return Usuario.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  /// Deleta um usuário pelo ID
  static Future<void> deletar(String id) async {
    final url = Uri.parse("$_baseUrl/$id");
    final headers = await _getHeaders();
    
    print("=== DELETAR USUÁRIO ===");
    print("URL: $url");
    
    final resp = await http.delete(url, headers: headers);

    print("Status: ${resp.statusCode}");
    print("=======================");

    if (resp.statusCode != 200 && resp.statusCode != 204) {
      throw Exception("Erro ao deletar usuário: ${resp.body}");
    }
  }

  // =============================
  // HELPERS DE VERIFICAÇÃO
  // =============================

  /// Verifica se o usuário está autenticado
  static Future<bool> estaAutenticado() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  /// Obtém o token atual (para debug)
  static Future<String?> getToken() async {
    return await _getToken();
  }
}
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../api/usuario_api.dart';
import '../../dominio/entidades/usuario.dart';

class AtualizarDadosControlador extends ChangeNotifier {
  // Estados de UI
  String? fotoBase64;
  bool carregandoFoto = false;
  bool _carregando = false;
  String? _erro;
  String? _sucesso;
  Usuario? _usuarioAtual;

  // Getters
  bool get carregando => _carregando;
  String? get erro => _erro;
  String? get sucesso => _sucesso;
  Usuario? get usuarioAtual => _usuarioAtual;

  // Compatibilidade com código antigo
  String? get mensagemErro => _erro;

  /// Carrega a foto inicial do usuário atual
  Future<void> carregarFotoInicial() async {
    try {
      final usuario = await UsuarioApi.getMe(); // CORRIGIDO: me() → getMe()
      fotoBase64 = usuario.fotoBase64;
      _usuarioAtual = usuario;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar foto inicial: $e'); // CORRIGIDO: print → debugPrint
    }
  }

  /// Carrega todos os dados do usuário atual
  Future<void> carregarUsuarioAtual() async {
    _carregando = true;
    notifyListeners();

    try {
      _usuarioAtual = await UsuarioApi.getMe(); // CORRIGIDO: me() → getMe()
      fotoBase64 = _usuarioAtual?.fotoBase64;
      _erro = null;
      _carregando = false;
      notifyListeners();
    } catch (e) {
      _erro = 'Erro ao carregar dados do usuário';
      _carregando = false;
      notifyListeners();
    }
  }

  /// Atualiza dados básicos (nome e email) - mantém assinatura antiga
  Future<void> atualizarDados({
    required String nome,
    required String novoEmail,
  }) async {
    _carregando = true;
    _erro = null;
    _sucesso = null;
    notifyListeners();

    try {
      await UsuarioApi.atualizarMe(
        nome: nome != _usuarioAtual?.nome ? nome : null,
        email: novoEmail != _usuarioAtual?.email ? novoEmail : null,
      );

      _usuarioAtual = await UsuarioApi.getMe(); // CORRIGIDO: me() → getMe()
      _sucesso = 'Dados atualizados com sucesso!';
      _carregando = false;
      notifyListeners();
    } catch (e) {
      _erro = _tratarErro(e.toString());
      _carregando = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Atualiza a foto do perfil
  Future<void> atualizarFoto({
    required File arquivo,
    required String uid, // Mantém por compatibilidade, mas não usa
  }) async {
    try {
      carregandoFoto = true;
      notifyListeners();

      // Converte arquivo para base64
      final bytes = await arquivo.readAsBytes();
      final base64String = base64Encode(bytes);

      // Atualiza no backend
      await UsuarioApi.atualizarMe(fotoBase64: base64String);

      // Atualiza localmente
      fotoBase64 = base64String;
      
      carregandoFoto = false;
      notifyListeners();
    } catch (e) {
      carregandoFoto = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Atualiza a foto a partir de uma string base64 diretamente
  Future<void> atualizarFotoBase64(String base64String) async {
    try {
      carregandoFoto = true;
      notifyListeners();

      await UsuarioApi.atualizarMe(fotoBase64: base64String);

      fotoBase64 = base64String;
      
      carregandoFoto = false;
      notifyListeners();
    } catch (e) {
      carregandoFoto = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Remove a foto do perfil
  Future<void> removerFoto() async {
    try {
      carregandoFoto = true;
      notifyListeners();

      await UsuarioApi.atualizarMe(fotoBase64: null);

      fotoBase64 = null;
      
      carregandoFoto = false;
      notifyListeners();
    } catch (e) {
      carregandoFoto = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Atualiza o nível do usuário
  Future<void> atualizarNivel(String nivel) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      await UsuarioApi.atualizarMe(nivel: nivel);
      
      _usuarioAtual = await UsuarioApi.getMe(); // CORRIGIDO: me() → getMe()
      _sucesso = 'Nível atualizado com sucesso!';
      _carregando = false;
      notifyListeners();
    } catch (e) {
      _erro = _tratarErro(e.toString());
      _carregando = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Atualiza a senha do usuário
  Future<void> atualizarSenha({
    required String novaSenha,
  }) async {
    if (novaSenha.length < 6) {
      _erro = 'Senha deve ter no mínimo 6 caracteres';
      notifyListeners();
      throw Exception(_erro);
    }

    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      await UsuarioApi.atualizarMe(senha: novaSenha);
      
      _sucesso = 'Senha atualizada com sucesso!';
      _carregando = false;
      notifyListeners();
    } catch (e) {
      _erro = _tratarErro(e.toString());
      _carregando = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Atualização completa com todos os campos opcionais
  Future<void> atualizarCompleto({
    String? nome,
    String? email,
    String? senha,
    String? fotoBase64,
    String? nivel,
  }) async {
    _carregando = true;
    _erro = null;
    _sucesso = null;
    notifyListeners();

    try {
      await UsuarioApi.atualizarMe(
        nome: nome,
        email: email,
        senha: senha,
        fotoBase64: fotoBase64,
        nivel: nivel,
      );

      _usuarioAtual = await UsuarioApi.getMe(); // CORRIGIDO: me() → getMe()
      this.fotoBase64 = _usuarioAtual?.fotoBase64;
      _sucesso = 'Perfil atualizado com sucesso!';
      _carregando = false;
      notifyListeners();
    } catch (e) {
      _erro = _tratarErro(e.toString());
      _carregando = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Deleta a conta do usuário
  Future<void> deletarConta() async {
    if (_usuarioAtual == null) {
      _erro = 'Usuário não encontrado';
      notifyListeners();
      throw Exception(_erro);
    }

    _carregando = true;
    notifyListeners();

    try {
      await UsuarioApi.deletar(_usuarioAtual!.id);
      await UsuarioApi.logout();

      _carregando = false;
      notifyListeners();
    } catch (e) {
      _erro = 'Erro ao deletar conta. Tente novamente.';
      _carregando = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Limpa mensagens de erro e sucesso
  void limparMensagens() {
    _erro = null;
    _sucesso = null;
    notifyListeners();
  }

  /// Trata mensagens de erro
  String _tratarErro(String erro) {
    if (erro.contains('Email já está em uso')) {
      return 'Este email já está cadastrado';
    }
    if (erro.contains('SocketException') || erro.contains('Failed host lookup')) {
      return 'Sem conexão com o servidor';
    }
    if (erro.contains('TimeoutException')) {
      return 'Tempo de conexão esgotado';
    }
    if (erro.contains('401')) {
      return 'Não autorizado. Faça login novamente.';
    }
    if (erro.contains('404')) {
      return 'Usuário não encontrado';
    }
    if (erro.contains('409')) {
      return 'Este email já está em uso';
    }
    return 'Erro ao atualizar perfil. Tente novamente.';
  }
}
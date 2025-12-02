import 'package:flutter/material.dart';
import '../../../api/usuario_api.dart';
import '../../dominio/entidades/usuario.dart';

class LoginControlador extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool _carregando = false;
  bool _senhaVisivel = false;
  String? _erro;
  Usuario? _usuarioLogado;

  bool get carregando => _carregando;
  bool get senhaVisivel => _senhaVisivel;
  String? get erro => _erro;
  Usuario? get usuarioLogado => _usuarioLogado;

  String? get mensagemErro => _erro;

  void alternarVisibilidadeSenha() {
    _senhaVisivel = !_senhaVisivel;
    notifyListeners();
  }

  void limparErro() {
    _erro = null;
    notifyListeners();
  }

  String? validarEmail(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Digite seu email';
    }
    if (!valor.contains('@') || !valor.contains('.')) {
      return 'Email inválido';
    }
    return null;
  }

  String? validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Digite sua senha';
    }
    if (valor.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  Future<bool> login({
    required String email,
    required String senha,
  }) async {
    if (emailController.text.isEmpty) emailController.text = email;
    if (senhaController.text.isEmpty) senhaController.text = senha;
    
    return await fazerLogin();
  }

  Future<bool> fazerLogin() async {
    _erro = null;

    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (email.isEmpty) {
      _erro = 'Digite seu email';
      notifyListeners();
      return false;
    }

    if (senha.isEmpty) {
      _erro = 'Digite sua senha';
      notifyListeners();
      return false;
    }

    if (senha.length < 6) {
      _erro = 'Senha deve ter no mínimo 6 caracteres';
      notifyListeners();
      return false;
    }

    _carregando = true;
    notifyListeners();

    try {
      await UsuarioApi.login(
        email: email,
        senha: senha,
      );

      _usuarioLogado = await UsuarioApi.getMe();

      _carregando = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      _erro = _tratarErro(e.toString());
      _carregando = false;
      notifyListeners();
      
      return false;
    }
  }

  Future<void> fazerLogout() async {
    await UsuarioApi.logout();
    _usuarioLogado = null;
    emailController.clear();
    senhaController.clear();
    _erro = null;
    notifyListeners();
  }

  Future<bool> verificarAutenticacao() async {
    try {
      final autenticado = await UsuarioApi.estaAutenticado();
      
      if (autenticado) {
        _usuarioLogado = await UsuarioApi.getMe();
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('Erro ao verificar autenticação: $e');
      return false;
    }
  }

  String _tratarErro(String erro) {
    if (erro.contains('Usuário não encontrado')) {
      return 'Email não cadastrado';
    }
    if (erro.contains('Senha incorreta')) {
      return 'Senha incorreta';
    }
    if (erro.contains('SocketException') || erro.contains('Failed host lookup')) {
      return 'Sem conexão com o servidor';
    }
    if (erro.contains('TimeoutException')) {
      return 'Tempo de conexão esgotado';
    }
    if (erro.contains('401')) {
      return 'Email ou senha incorretos';
    }
    if (erro.contains('404')) {
      return 'Usuário não encontrado';
    }
    return 'Erro ao fazer login. Tente novamente.';
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}
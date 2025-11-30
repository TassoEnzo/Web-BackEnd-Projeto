import 'package:flutter/material.dart';
import '../../../api/usuario_api.dart';
import '../../dominio/entidades/usuario.dart';

class LoginControlador extends ChangeNotifier {
  // Estado do formulário
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  // Estados de UI
  bool _carregando = false;
  bool _senhaVisivel = false;
  String? _erro;
  Usuario? _usuarioLogado;

  // Getters
  bool get carregando => _carregando;
  bool get senhaVisivel => _senhaVisivel;
  String? get erro => _erro;
  Usuario? get usuarioLogado => _usuarioLogado;

  // Compatibilidade com código antigo
  String? get mensagemErro => _erro;

  // Alterna visibilidade da senha
  void alternarVisibilidadeSenha() {
    _senhaVisivel = !_senhaVisivel;
    notifyListeners();
  }

  // Limpa mensagens de erro
  void limparErro() {
    _erro = null;
    notifyListeners();
  }

  // Valida email
  String? validarEmail(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Digite seu email';
    }
    if (!valor.contains('@') || !valor.contains('.')) {
      return 'Email inválido';
    }
    return null;
  }

  // Valida senha
  String? validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Digite sua senha';
    }
    if (valor.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  // Faz login (mantém assinatura antiga para compatibilidade)
  Future<bool> login({
    required String email,
    required String senha,
  }) async {
    // Define valores nos controllers se não estiverem setados
    if (emailController.text.isEmpty) emailController.text = email;
    if (senhaController.text.isEmpty) senhaController.text = senha;
    
    return await fazerLogin();
  }

  // Faz login (nova versão)
  Future<bool> fazerLogin() async {
    // Limpa erro anterior
    _erro = null;

    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    // Validações básicas
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
      // Chama API de login
      await UsuarioApi.login(
        email: email,
        senha: senha,
      );

      // Busca dados do usuário logado - CORRIGIDO: me() -> getMe()
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

  // Faz logout
  Future<void> fazerLogout() async {
    await UsuarioApi.logout();
    _usuarioLogado = null;
    emailController.clear();
    senhaController.clear();
    _erro = null;
    notifyListeners();
  }

  // Verifica se está autenticado
  Future<bool> verificarAutenticacao() async {
    try {
      final autenticado = await UsuarioApi.estaAutenticado();
      
      if (autenticado) {
        // Tenta buscar dados do usuário - CORRIGIDO: me() -> getMe()
        _usuarioLogado = await UsuarioApi.getMe();
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      // CORRIGIDO: Removido print, usando debugPrint
      debugPrint('Erro ao verificar autenticação: $e');
      return false;
    }
  }

  // Trata mensagens de erro
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
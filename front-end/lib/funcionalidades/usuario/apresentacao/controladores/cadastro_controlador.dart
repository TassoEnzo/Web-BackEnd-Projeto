import 'package:flutter/material.dart';
import '../../../api/usuario_api.dart';

class CadastroControlador extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  bool _carregando = false;
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  String? _erro;
  String? _nivelSelecionado;
  String? _fotoBase64;

  bool get carregando => _carregando;
  bool get senhaVisivel => _senhaVisivel;
  bool get confirmarSenhaVisivel => _confirmarSenhaVisivel;
  String? get erro => _erro;
  String? get nivelSelecionado => _nivelSelecionado;
  String? get fotoBase64 => _fotoBase64;

  String? get mensagemErro => _erro;
  
  bool get temFalha => _erro != null;

  final List<String> niveisDisponiveis = [
    'iniciante',
    'intermediario',
    'avancado',
  ];

  void alternarVisibilidadeSenha() {
    _senhaVisivel = !_senhaVisivel;
    notifyListeners();
  }

  void alternarVisibilidadeConfirmarSenha() {
    _confirmarSenhaVisivel = !_confirmarSenhaVisivel;
    notifyListeners();
  }

  void setNivel(String? nivel) {
    _nivelSelecionado = nivel;
    notifyListeners();
  }

  void setFoto(String? fotoBase64) {
    _fotoBase64 = fotoBase64;
    notifyListeners();
  }

  void limparErro() {
    _erro = null;
    notifyListeners();
  }

  void limparCampos() {
    nomeController.clear();
    emailController.clear();
    senhaController.clear();
    confirmarSenhaController.clear();
    _nivelSelecionado = null;
    _fotoBase64 = null;
    _erro = null;
    notifyListeners();
  }

  String? validarNome(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Digite seu nome';
    }
    if (valor.trim().length < 3) {
      return 'Nome deve ter no mínimo 3 caracteres';
    }
    return null;
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
      return 'Digite uma senha';
    }
    if (valor.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  String? validarConfirmarSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Confirme sua senha';
    }
    if (valor != senhaController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    _erro = null;

    if (nome.isEmpty) {
      _erro = "Campo nome não pode estar vazio";
      notifyListeners();
      return false;
    }

    if (email.isEmpty) {
      _erro = "Campo e-mail não pode estar vazio";
      notifyListeners();
      return false;
    }

    if (senha.isEmpty) {
      _erro = "Campo senha não pode estar vazio";
      notifyListeners();
      return false;
    }

    if (senha.length < 6) {
      _erro = "A senha deve ter pelo menos 6 caracteres.";
      notifyListeners();
      return false;
    }

    _carregando = true;
    notifyListeners();

    try {
      await UsuarioApi.criar(
        nome: nome,
        email: email,
        senha: senha,
        nivel: _nivelSelecionado,
        fotoBase64: _fotoBase64,
      );

      await UsuarioApi.login(
        email: email,
        senha: senha,
      );

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

  Future<bool> cadastrarNovo() async {
    return await cadastrar(
      nome: nomeController.text.trim(),
      email: emailController.text.trim(),
      senha: senhaController.text,
    );
  }

  String _tratarErro(String erro) {
    if (erro.contains('Email já está em uso')) {
      return 'Este email já está cadastrado';
    }
    
    if (erro.contains('email-already-in-use')) {
      return 'Este email já está cadastrado';
    }
    if (erro.contains('invalid-email')) {
      return 'Email inválido';
    }
    if (erro.contains('weak-password')) {
      return 'Senha muito fraca';
    }
    if (erro.contains('operation-not-allowed')) {
      return 'Operação não permitida';
    }
    
    if (erro.contains('SocketException') || erro.contains('Failed host lookup')) {
      return 'Sem conexão com o servidor';
    }
    if (erro.contains('TimeoutException')) {
      return 'Tempo de conexão esgotado';
    }
    
    if (erro.contains('400')) {
      return 'Dados inválidos. Verifique os campos.';
    }
    if (erro.contains('409')) {
      return 'Este email já está cadastrado';
    }
    if (erro.contains('500')) {
      return 'Erro no servidor. Tente novamente.';
    }
    
    return 'Erro inesperado no cadastro.';
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }
}
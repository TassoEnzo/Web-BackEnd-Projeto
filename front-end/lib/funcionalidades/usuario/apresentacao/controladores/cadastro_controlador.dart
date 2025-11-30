import 'package:flutter/material.dart';
import '../../../api/usuario_api.dart';

class CadastroControlador extends ChangeNotifier {
  // Estado do formulário
  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  // Estados de UI
  bool _carregando = false;
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  String? _erro;
  String? _nivelSelecionado;
  String? _fotoBase64;

  // Getters
  bool get carregando => _carregando;
  bool get senhaVisivel => _senhaVisivel;
  bool get confirmarSenhaVisivel => _confirmarSenhaVisivel;
  String? get erro => _erro;
  String? get nivelSelecionado => _nivelSelecionado;
  String? get fotoBase64 => _fotoBase64;

  // Compatibilidade com código antigo que usa "falha"
  String? get mensagemErro => _erro;
  
  // Para manter compatibilidade com código que verifica falha != null
  bool get temFalha => _erro != null;

  // Lista de níveis disponíveis
  final List<String> niveisDisponiveis = [
    'iniciante',
    'intermediario',
    'avancado',
  ];

  // Alterna visibilidade da senha
  void alternarVisibilidadeSenha() {
    _senhaVisivel = !_senhaVisivel;
    notifyListeners();
  }

  // Alterna visibilidade da confirmação de senha
  void alternarVisibilidadeConfirmarSenha() {
    _confirmarSenhaVisivel = !_confirmarSenhaVisivel;
    notifyListeners();
  }

  // Define o nível selecionado
  void setNivel(String? nivel) {
    _nivelSelecionado = nivel;
    notifyListeners();
  }

  // Define a foto em base64
  void setFoto(String? fotoBase64) {
    _fotoBase64 = fotoBase64;
    notifyListeners();
  }

  // Limpa mensagens de erro
  void limparErro() {
    _erro = null;
    notifyListeners();
  }

  // Limpa todos os campos
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

  // Validações
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

  /// MÉTODO PRINCIPAL - Mantém assinatura igual ao código antigo do Firebase
  /// Uso: await ctrl.cadastrar(nome: '...', email: '...', senha: '...');
  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    // Limpa erro anterior
    _erro = null;

    // Validações (exatamente como no código Firebase)
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

    // Inicia loading
    _carregando = true;
    notifyListeners();

    try {
      // Chama API de cadastro
      final usuario = await UsuarioApi.criar(
        nome: nome,
        email: email,
        senha: senha,
        nivel: _nivelSelecionado,
        fotoBase64: _fotoBase64,
      );

      print('Usuário cadastrado com sucesso: ${usuario.id}');

      // Faz login automático após cadastro
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

  /// Método alternativo que usa os controllers
  /// Uso: await ctrl.cadastrarNovo();
  Future<bool> cadastrarNovo() async {
    return await cadastrar(
      nome: nomeController.text.trim(),
      email: emailController.text.trim(),
      senha: senhaController.text,
    );
  }

  // Trata mensagens de erro (compatível com códigos Firebase)
  String _tratarErro(String erro) {
    // Erros de validação
    if (erro.contains('Email já está em uso')) {
      return 'Este email já está cadastrado';
    }
    
    // Códigos Firebase traduzidos
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
    
    // Erros de conexão
    if (erro.contains('SocketException') || erro.contains('Failed host lookup')) {
      return 'Sem conexão com o servidor';
    }
    if (erro.contains('TimeoutException')) {
      return 'Tempo de conexão esgotado';
    }
    
    // Erros HTTP
    if (erro.contains('400')) {
      return 'Dados inválidos. Verifique os campos.';
    }
    if (erro.contains('409')) {
      return 'Este email já está cadastrado';
    }
    if (erro.contains('500')) {
      return 'Erro no servidor. Tente novamente.';
    }
    
    // Erro genérico (igual ao Firebase)
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
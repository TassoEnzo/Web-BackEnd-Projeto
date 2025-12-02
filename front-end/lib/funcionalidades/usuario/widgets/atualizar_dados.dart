import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../api/usuario_api.dart';
import '../dominio/entidades/usuario.dart';

class AtualizarDadosPagina extends StatefulWidget {
  final Usuario usuario;

  const AtualizarDadosPagina({
    super.key,
    required this.usuario,
  });

  @override
  State<AtualizarDadosPagina> createState() => _AtualizarDadosPaginaState();
}

class _AtualizarDadosPaginaState extends State<AtualizarDadosPagina> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _senhaController;
  late TextEditingController _confirmarSenhaController;

  bool _carregando = false;
  bool _carregandoFoto = false;
  bool _alterandoSenha = false;
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  String? _fotoBase64;
  String? _nivelSelecionado;

  final List<String> _niveisDisponiveis = [
    'iniciante',
    'intermediario',
    'avancado',
  ];

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.usuario.nome);
    _emailController = TextEditingController(text: widget.usuario.email);
    _senhaController = TextEditingController();
    _confirmarSenhaController = TextEditingController();
    _fotoBase64 = widget.usuario.fotoBase64;
    _nivelSelecionado = widget.usuario.nivel;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _selecionarFoto(ImageSource source) async {
    try {
      final img = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (img == null) return;

      setState(() => _carregandoFoto = true);

      final bytes = await File(img.path).readAsBytes();
      final base64String = base64Encode(bytes);

      setState(() {
        _fotoBase64 = base64String;
        _carregandoFoto = false;
      });
    } catch (e) {
      setState(() => _carregandoFoto = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar foto: $e')),
        );
      }
    }
  }

  void _mostrarOpcoesImagem() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SizedBox(
        height: 200,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.photo, color: Colors.white),
              title: const Text(
                "Escolher da Galeria",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _selecionarFoto(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text(
                "Tirar Foto",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _selecionarFoto(ImageSource.camera);
              },
            ),
            if (_fotoBase64 != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  "Remover Foto",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _fotoBase64 = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _atualizar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    try {
      await UsuarioApi.atualizarMe(
        nome: _nomeController.text.trim() != widget.usuario.nome
            ? _nomeController.text.trim()
            : null,
        email: _emailController.text.trim() != widget.usuario.email
            ? _emailController.text.trim()
            : null,
        senha: _alterandoSenha && _senhaController.text.isNotEmpty
            ? _senhaController.text
            : null,
        fotoBase64: _fotoBase64 != widget.usuario.fotoBase64
            ? _fotoBase64
            : null,
        nivel: _nivelSelecionado != widget.usuario.nivel
            ? _nivelSelecionado
            : null,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Dados atualizados com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );

      if (_alterandoSenha) {
        _senhaController.clear();
        _confirmarSenhaController.clear();
        setState(() => _alterandoSenha = false);
      }

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao atualizar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _deletarConta() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2E3D3C),
        title: const Text(
          '⚠️ Deletar Conta',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Esta ação é IRREVERSÍVEL! Todos os seus dados serão perdidos permanentemente.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('DELETAR'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    setState(() => _carregando = true);

    try {
      await UsuarioApi.deletar(widget.usuario.id);
      await UsuarioApi.logout();

      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil('/inicial', (_) => false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao deletar conta: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider avatar;
    if (_fotoBase64 != null && _fotoBase64!.isNotEmpty) {
      try {
        avatar = MemoryImage(base64Decode(_fotoBase64!));
      } catch (_) {
        avatar = const AssetImage("assets/images/avatar.png");
      }
    } else {
      avatar = const AssetImage("assets/images/avatar.png");
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1B2B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2B2A),
        elevation: 0,
        title: const Text("Atualizar Dados"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2F443F),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _mostrarOpcoesImagem,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundImage: avatar,
                        ),
                      ),
                      Positioned(
                        right: -5,
                        bottom: -5,
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 22,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (_carregandoFoto)
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),

                const SizedBox(height: 20),

                _campo("Nome", _nomeController, validator: (v) {
                  if (v == null || v.isEmpty) return "Digite seu nome";
                  if (v.trim().length < 3) return "Nome muito curto";
                  return null;
                }),

                const SizedBox(height: 20),

                _campo("E-mail", _emailController, validator: (v) {
                  if (v == null || v.isEmpty) return "Digite seu e-mail";
                  if (!v.contains('@') || !v.contains('.')) {
                    return "E-mail inválido";
                  }
                  return null;
                }),

                const SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nível",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _nivelSelecionado,
                      dropdownColor: const Color(0xFF1E2E2D),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF1E2E2D),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: _niveisDisponiveis.map((nivel) {
                        return DropdownMenuItem(
                          value: nivel,
                          child: Text(
                            nivel[0].toUpperCase() + nivel.substring(1),
                          ),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        setState(() => _nivelSelecionado = valor);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SwitchListTile(
                  title: const Text(
                    "Alterar senha",
                    style: TextStyle(color: Colors.white),
                  ),
                  value: _alterandoSenha,
                  activeColor: Colors.white,
                  onChanged: (valor) {
                    setState(() {
                      _alterandoSenha = valor;
                      if (!valor) {
                        _senhaController.clear();
                        _confirmarSenhaController.clear();
                      }
                    });
                  },
                ),

                if (_alterandoSenha) ...[
                  const SizedBox(height: 10),
                  _campo(
                    "Nova Senha",
                    _senhaController,
                    obscureText: !_senhaVisivel,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _senhaVisivel
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() => _senhaVisivel = !_senhaVisivel);
                      },
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Digite a nova senha";
                      if (v.length < 6) {
                        return "Senha deve ter no mínimo 6 caracteres";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _campo(
                    "Confirmar Nova Senha",
                    _confirmarSenhaController,
                    obscureText: !_confirmarSenhaVisivel,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmarSenhaVisivel
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() => _confirmarSenhaVisivel =
                            !_confirmarSenhaVisivel);
                      },
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Confirme a nova senha";
                      }
                      if (v != _senhaController.text) {
                        return "As senhas não coincidem";
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _carregando ? null : _atualizar,
                    icon: _carregando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      _carregando ? "Salvando..." : "Salvar alterações",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                const Divider(color: Colors.white24),
                const SizedBox(height: 10),

                TextButton.icon(
                  onPressed: _carregando ? null : _deletarConta,
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  label: const Text(
                    'Deletar Conta',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campo(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1E2E2D),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}

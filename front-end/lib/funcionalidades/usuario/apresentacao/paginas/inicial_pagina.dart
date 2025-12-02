import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../usuario/apresentacao/paginas/cadastro_pagina.dart';
import '../../../usuario/apresentacao/paginas/escolha_nivel_pagina.dart';
import '../../../treino/apresentacao/paginas/treino_pagina.dart';
import '../../../usuario/apresentacao/controladores/login_controlador.dart';

class InicioPagina extends StatefulWidget {
  const InicioPagina({super.key});

  @override
  State<InicioPagina> createState() => _InicioPaginaState();
}

class _InicioPaginaState extends State<InicioPagina> {
  late LoginControlador _loginCtrl;

  @override
  void initState() {
    super.initState();
    _loginCtrl = LoginControlador();
    _verificarAutenticacao();
  }

  @override
  void dispose() {
    _loginCtrl.dispose();
    super.dispose();
  }

  Future<void> _verificarAutenticacao() async {
    final autenticado = await _loginCtrl.verificarAutenticacao();
    if (!mounted) return;
    
    if (autenticado && _loginCtrl.usuarioLogado != null) {
      final usuario = _loginCtrl.usuarioLogado!;
      
      if (usuario.nivel == null || usuario.nivel!.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const EscolhaNivelPagina(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TreinoPagina(nivel: usuario.nivel!),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _loginCtrl,
      child: Consumer<LoginControlador>(
        builder: (context, ctrl, _) {
          return Scaffold(
            backgroundColor: const Color(0xFF1B2B2A),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 180,
                      child: Image.asset(
                        "assets/images/logo_principal.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    TextField(
                      controller: ctrl.emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Endereço de email",
                        hintStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.email, color: Colors.white70),
                        filled: true,
                        fillColor: const Color(0xFF7A8F85),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextField(
                      controller: ctrl.senhaController,
                      obscureText: !ctrl.senhaVisivel,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Senha",
                        hintStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                        suffixIcon: IconButton(
                          icon: Icon(
                            ctrl.senhaVisivel 
                              ? Icons.visibility 
                              : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: ctrl.alternarVisibilidadeSenha,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF7A8F85),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    
                    ctrl.carregando
                        ? const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          )
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final navigator = Navigator.of(context);
                                
                                final sucesso = await ctrl.fazerLogin();
                                
                                if (!mounted) return;
                                
                                if (sucesso && ctrl.usuarioLogado != null) {
                                  final usuario = ctrl.usuarioLogado!;
                                  
                                  if (usuario.nivel == null || usuario.nivel!.isEmpty) {
                                    navigator.pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => const EscolhaNivelPagina(),
                                      ),
                                    );
                                  } else {
                                    navigator.pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => TreinoPagina(nivel: usuario.nivel!),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7A8F85),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                    
                    const SizedBox(height: 20),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Não tem uma conta? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CadastroPagina(),
                              ),
                            );
                          },
                          child: const Text(
                            "Inscreva-se",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    if (ctrl.erro != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  ctrl.erro!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
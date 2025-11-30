import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../funcionalidades/api/usuario_api.dart';
import '../dominio/entidades/usuario.dart';
import 'atualizar_dados.dart';

class PainelUsuario {
  static void abrir(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'PainelUsuario',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: width * 0.6,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E3D3C),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: FutureBuilder<Usuario>(
                  future: UsuarioApi.getMe(), // CORRIGIDO: me() → getMe()
                  builder: (context, snapshot) {
                    // Loading
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    // Erro
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Erro ao carregar dados',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${snapshot.error}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Fechar'),
                            ),
                          ],
                        ),
                      );
                    }

                    // Sucesso
                    final usuario = snapshot.data!;
                    final nome = usuario.nome;
                    final email = usuario.email;
                    final fotoBase64 = usuario.fotoBase64;

                    ImageProvider avatar;
                    if (fotoBase64 != null && fotoBase64.isNotEmpty) {
                      try {
                        avatar = MemoryImage(base64Decode(fotoBase64));
                      } catch (e) {
                        debugPrint('Erro ao decodificar foto: $e');
                        avatar = const AssetImage('assets/images/avatar.png');
                      }
                    } else {
                      avatar = const AssetImage('assets/images/avatar.png');
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cabeçalho com foto e nome
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: avatar,
                                backgroundColor: Colors.grey[700],
                                onBackgroundImageError: (exception, stackTrace) {
                                  debugPrint('Erro ao carregar imagem: $exception');
                                },
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Bem-vindo, $nome 👋",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),
                        const Divider(color: Colors.white24),

                        // Opção de atualizar dados
                        ListTile(
                          leading: const Icon(Icons.edit, color: Colors.white),
                          title: const Text(
                            'Atualizar Dados',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AtualizarDadosPagina(
                                  usuario: usuario,
                                ),
                              ),
                            );
                          },
                        ),

                        const Spacer(),

                        // Botão de sair
                        ListTile(
                          leading: const Icon(Icons.exit_to_app, color: Colors.red),
                          title: const Text(
                            'Sair',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () async {
                            Navigator.pop(context);

                            // Mostra diálogo de confirmação
                            final confirmar = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: const Color(0xFF2E3D3C),
                                title: const Text(
                                  'Confirmar Saída',
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: const Text(
                                  'Deseja realmente sair da sua conta?',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Sair'),
                                  ),
                                ],
                              ),
                            );

                            if (confirmar == true) {
                              await UsuarioApi.logout();

                              if (context.mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/inicial',
                                  (_) => false,
                                );
                              }
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero)
              .animate(animation),
          child: child,
        );
      },
    );
  }
}
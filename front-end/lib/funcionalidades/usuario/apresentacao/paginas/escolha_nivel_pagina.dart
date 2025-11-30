import 'package:flutter/material.dart';
import '../../../treino/apresentacao/paginas/treino_pagina.dart';
import '../../../usuario/apresentacao/controladores/atualizar_dados_controlador.dart';

class EscolhaNivelPagina extends StatefulWidget {
  const EscolhaNivelPagina({super.key});

  @override
  State<EscolhaNivelPagina> createState() => _EscolhaNivelPaginaState();
}

class _EscolhaNivelPaginaState extends State<EscolhaNivelPagina> {
  bool _salvando = false;
  String? _erro;

  Future<void> salvarNivel(String nivel) async {
    setState(() {
      _salvando = true;
      _erro = null;
    });

    try {
      // Usa o controlador correto
      final ctrl = AtualizarDadosControlador();
      
      // Atualiza o nível no backend
      await ctrl.atualizarNivel(nivel);
      
      if (!mounted) return;

      // Navega para a página de treinos
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TreinoPagina(nivel: nivel),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _erro = 'Erro ao salvar nível. Tente novamente.';
        _salvando = false;
      });
      
      // Exibe SnackBar com erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_erro!),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildCard({
    required String titulo,
    required String descricao,
    required String imagem,
    required Color cor,
    required String nivel,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  descricao,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _salvando ? null : () => salvarNivel(nivel),
                  icon: _salvando
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(_salvando ? "Salvando..." : "Começar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            flex: 1,
            child: Image.asset(
              imagem,
              width: 90,
              height: 90,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback se a imagem não existir
                return Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    size: 40,
                    color: Colors.black54,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2B2A),
        elevation: 0,
        title: const Text(
          'Escolha seu Nível',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Selecione o nível que melhor descreve sua experiência',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                _buildCard(
                  titulo: "Iniciante",
                  descricao: "Nunca treinei ou estou começando agora.",
                  imagem: "assets/images/treino_iniciante.png",
                  cor: const Color(0xFFA8D5BA),
                  nivel: "iniciante",
                ),
                _buildCard(
                  titulo: "Intermediário",
                  descricao: "Já treino há 1 ano de forma regular.",
                  imagem: "assets/images/treino_intermediario.png",
                  cor: const Color(0xFFF4EFEA),
                  nivel: "intermediario",
                ),
                _buildCard(
                  titulo: "Avançado",
                  descricao: "Treino há mais de 2 anos de forma consistente.",
                  imagem: "assets/images/treino_avancado.png",
                  cor: const Color(0xFF7A8F85),
                  nivel: "avancado",
                ),
                const SizedBox(height: 80), // Espaço para mensagem de erro
              ],
            ),
          ),
          
          // Mensagem de erro flutuante
          if (_erro != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _erro!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _erro = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
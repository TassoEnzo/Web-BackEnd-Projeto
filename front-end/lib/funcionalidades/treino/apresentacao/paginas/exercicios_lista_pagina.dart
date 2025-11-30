import 'package:flutter/material.dart';
import '../../../treino/dominio/entidades/exercicios.dart';
import '/funcionalidades/api/exercicios_api.dart';
import '../../../usuario/widgets/painel_usuario.dart';
import '../../widgets/imagem_exercicio_widget.dart'; // NOVO IMPORT

class ExerciciosListaPagina extends StatefulWidget {
  const ExerciciosListaPagina({super.key});

  @override
  State<ExerciciosListaPagina> createState() => _ExerciciosListaPaginaState();
}

class _ExerciciosListaPaginaState extends State<ExerciciosListaPagina> {
  late Future<List<Exercicio>> _futureExercicios;
  String selectedTipo = "academia";

  @override
  void initState() {
    super.initState();
    _carregarExercicios();
  }

  void _carregarExercicios() {
    _futureExercicios = ExerciciosApi.listar().then(
      (lista) {
        print('🔵 Quantidade de itens recebidos: ${lista.length}');
        
        return lista.map((json) {
          try {
            print('🔵 Convertendo: ${json['nome']}');
            return Exercicio.fromJson(json);
          } catch (e) {
            print('🔴 ERRO ao converter exercício: $e');
            print('🔴 JSON problemático: $json');
            rethrow;
          }
        }).toList();
      },
    ).catchError((error) {
      print('🔴 ERRO GERAL: $error');
      throw error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2B2A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Exercícios",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Exercicio>>(
        future: _futureExercicios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Erro ao carregar exercícios",
                    style: TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${snapshot.error}",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _carregarExercicios();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1B2B2A),
                    ),
                    child: const Text("Tentar novamente"),
                  ),
                ],
              ),
            );
          }

          final lista = snapshot.data ?? [];
          
          print('🔵 Total de exercícios: ${lista.length}');
          print('🔵 Filtrando por: $selectedTipo');
          
          final listaFiltrada = lista.where((e) {
            final match = e.tipoEquipamento.toLowerCase() == selectedTipo.toLowerCase();
            print('🔵 ${e.nome}: ${e.tipoEquipamento} == $selectedTipo? $match');
            return match;
          }).toList();

          print('🔵 Exercícios filtrados: ${listaFiltrada.length}');

          if (listaFiltrada.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum exercício encontrado.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: listaFiltrada.length,
            itemBuilder: (context, index) {
              final ex = listaFiltrada[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ex.nome,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B2B2A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // USA A IMAGEM DOS ASSETS
                    ImagemExercicioWidget(
                      nomeArquivo: ex.imagem, // ex: "supino_reto.jpg"
                      height: 180,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: ex.linkYoutube != null && ex.linkYoutube!.isNotEmpty
                            ? () {
                                Navigator.pushNamed(
                                  context,
                                  '/treino/video',
                                  arguments: {
                                    'titulo': ex.nome,
                                    'urlVideo': ex.linkYoutube,
                                    'imagem': ex.imagem,
                                  },
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B2B2A),
                          disabledBackgroundColor: Colors.grey[300],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(
                          Icons.play_arrow,
                          color: ex.linkYoutube != null ? Colors.white : Colors.grey,
                        ),
                        label: Text(
                          ex.linkYoutube != null ? "Assistir exercício" : "Sem vídeo",
                          style: TextStyle(
                            color: ex.linkYoutube != null ? Colors.white : Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xFF2E3D3C),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () => PainelUsuario.abrir(context),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.person, color: Colors.white70, size: 32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
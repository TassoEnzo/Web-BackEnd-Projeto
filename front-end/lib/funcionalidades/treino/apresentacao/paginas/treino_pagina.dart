import 'package:flutter/material.dart';
import '../../dominio/entidades/treino.dart';
import '../../../api/treino_api.dart';
import '../../../usuario/widgets/painel_usuario.dart';

class TreinoPagina extends StatefulWidget {
  final String nivel;
  const TreinoPagina({super.key, required this.nivel});

  @override
  State<TreinoPagina> createState() => _TreinoPaginaState();
}

class _TreinoPaginaState extends State<TreinoPagina> {
  List<Treino> _treinos = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarTreinos();
  }

  Future<void> _carregarTreinos() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final treinos = await TreinoApi.listarPorNivel(widget.nivel);
      setState(() {
        _treinos = treinos;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _erro = 'Erro ao carregar treinos: $e';
        _carregando = false;
      });
      print('Erro ao carregar treinos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2B2A),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Nível ${widget.nivel[0].toUpperCase()}${widget.nivel.substring(1)}",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarTreinos,
            tooltip: 'Recarregar',
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xFF2E3D3C),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              splashColor: Colors.white24,
              highlightColor: Colors.white10,
              onTap: () => PainelUsuario.abrir(context),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(
                  Icons.person,
                  color: Colors.white70,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white70,
        ),
      );
    }

    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white70,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                _erro!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _carregarTreinos,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar Novamente'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E5953),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_treinos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.fitness_center,
              color: Colors.white38,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum treino disponível\npara o nível ${widget.nivel}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: const Color(0xFF3E5953),
      onRefresh: _carregarTreinos,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _treinos.length,
        itemBuilder: (context, index) {
          final treino = _treinos[index];
          return _CardTreino(
            treino: treino,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/treino/exercicios',
                arguments: treino,
              );
            },
          );
        },
      ),
    );
  }
}

class _CardTreino extends StatelessWidget {
  final Treino treino;
  final VoidCallback onPressed;
  const _CardTreino({required this.treino, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3E5953),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFF2E3D3C),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.fitness_center,
                size: 40,
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    treino.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: FloatingActionButton.small(
              heroTag: "${treino.id}_fab",
              backgroundColor:
                  treino.botaoEscuro ? const Color(0xFF1B2B2A) : Colors.white,
              foregroundColor:
                  treino.botaoEscuro ? Colors.white : Colors.black,
              onPressed: onPressed,
              child: const Icon(Icons.play_arrow),
            ),
          ),
        ],
      ),
    );
  }
}
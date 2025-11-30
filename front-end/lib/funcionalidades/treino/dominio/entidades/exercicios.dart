import 'categoria.dart';

class Exercicio {
  final String id;
  final String nome;
  final String descricao;
  final String imagem;
  final String tipoEquipamento;
  final String? linkYoutube;
  final List<Categoria> categorias;

  Exercicio({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.imagem,
    required this.tipoEquipamento,
    this.linkYoutube,
    this.categorias = const [],
  });

  factory Exercicio.fromJson(Map<String, dynamic> json) {
    return Exercicio(
      id: json['id'] ?? '',
      nome: json['nome'] ?? 'Sem nome',
      descricao: json['descricao'] ?? '',
      imagem: json['imagem'] ?? 'placeholder.jpg',
      tipoEquipamento: (json['tipoEquipamento'] ?? 'ACADEMIA').toString().toLowerCase(),
      linkYoutube: json['linkYoutube'],
      categorias: (json['categorias'] as List<dynamic>?)
              ?.map((e) => Categoria.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'imagem': imagem,
      'tipoEquipamento': tipoEquipamento.toUpperCase(),
      'linkYoutube': linkYoutube,
      'categorias': categorias.map((c) => c.toJson()).toList(),
    };
  }
}
import 'exercicios.dart';

class Treino {
  final String id;
  final String titulo;
  final bool botaoEscuro;
  final String? linkYoutube;
  final String? nivel;
  final List<Exercicio> exercicios;
  final String? usuarioId;

  Treino({
    required this.id,
    required this.titulo,
    required this.botaoEscuro,
    this.linkYoutube,
    this.nivel,
    this.exercicios = const [],
    this.usuarioId,
  });

  Treino.novo({
    required this.titulo,
    required this.botaoEscuro,
    this.linkYoutube,
    this.nivel,
    this.exercicios = const [],
    this.usuarioId,
  }) : id = '';

  factory Treino.fromJson(Map<String, dynamic> json) {
    return Treino(
      id: json['id'] as String? ?? '',
      titulo: json['titulo'] as String? ?? 'Sem título',
      botaoEscuro: json['botaoEscuro'] as bool? ?? false,
      linkYoutube: json['linkYoutube'] as String?,
      nivel: json['nivel'] as String?,
      exercicios: (json['exercicios'] as List<dynamic>?)
              ?.map((e) => Exercicio.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      usuarioId: json['usuarioId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'botaoEscuro': botaoEscuro,
      if (linkYoutube != null) 'linkYoutube': linkYoutube,
      if (nivel != null) 'nivel': nivel,
      'exercicios': exercicios.map((e) => e.toJson()).toList(),
      if (usuarioId != null) 'usuarioId': usuarioId,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'titulo': titulo,
      'botaoEscuro': botaoEscuro,
      if (linkYoutube != null) 'linkYoutube': linkYoutube,
      'exerciciosIds': exercicios.map((e) => e.id).toList(),
      if (usuarioId != null) 'usuarioId': usuarioId,
    };
  }

  Treino copyWith({
    String? id,
    String? titulo,
    bool? botaoEscuro,
    String? linkYoutube,
    String? nivel,
    List<Exercicio>? exercicios,
    String? usuarioId,
  }) {
    return Treino(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      botaoEscuro: botaoEscuro ?? this.botaoEscuro,
      linkYoutube: linkYoutube ?? this.linkYoutube,
      nivel: nivel ?? this.nivel,
      exercicios: exercicios ?? this.exercicios,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }

  @override
  String toString() {
    return 'Treino(id: $id, titulo: $titulo, nivel: $nivel, exercicios: ${exercicios.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Treino && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
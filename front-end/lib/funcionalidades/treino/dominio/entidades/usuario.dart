class Usuario {
  final String id;
  final String nome;
  final String email;
  final String? fotoBase64;
  final String? nivel;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    this.fotoBase64,
    this.nivel,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      fotoBase64: json['fotoBase64'] as String?,
      nivel: json['nivel'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      if (fotoBase64 != null) 'fotoBase64': fotoBase64,
      if (nivel != null) 'nivel': nivel,
    };
  }

  Usuario copyWith({
    String? id,
    String? nome,
    String? email,
    String? fotoBase64,
    String? nivel,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      fotoBase64: fotoBase64 ?? this.fotoBase64,
      nivel: nivel ?? this.nivel,
    );
  }

  @override
  String toString() {
    return 'Usuario(id: $id, nome: $nome, email: $email, nivel: $nivel)';
  }

  // ADICIONE ESTE GETTER EXPLÍCITO (workaround)
  String? get foto => fotoBase64;
}
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

  // Factory constructor para criar Usuario a partir de JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      fotoBase64: json['fotoBase64'] as String?,
      nivel: json['nivel'] as String?,
    );
  }

  // Método para converter Usuario em JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      if (fotoBase64 != null) 'fotoBase64': fotoBase64,
      if (nivel != null) 'nivel': nivel,
    };
  }

  // Método copyWith para criar cópias modificadas
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

  // toString para facilitar debug
  @override
  String toString() {
    return 'Usuario(id: $id, nome: $nome, email: $email, nivel: $nivel, temFoto: ${fotoBase64 != null})';
  }

  // Equals e hashCode para comparações
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Usuario && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
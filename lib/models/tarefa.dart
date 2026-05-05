class Tarefa {
  final int? id;
  final String titulo;
  final String descricao;
  final String dataPrevista;
  final bool importante;
  final bool realizada;
  final String tipo;

  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.dataPrevista,
    required this.importante,
    required this.realizada,
    required this.tipo,
  });

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      dataPrevista: map['data_prevista'] as String,
      importante: (map['importante'] as int) == 1,
      realizada: (map['realizada'] as int) == 1,
      tipo: map['tipo'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data_prevista': dataPrevista,
      'importante': importante ? 1 : 0,
      'realizada': realizada ? 1 : 0,
      'tipo': tipo,
    };
  }

  Tarefa copyWith({
    int? id,
    String? titulo,
    String? descricao,
    String? dataPrevista,
    bool? importante,
    bool? realizada,
    String? tipo,
  }) {
    return Tarefa(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      dataPrevista: dataPrevista ?? this.dataPrevista,
      importante: importante ?? this.importante,
      realizada: realizada ?? this.realizada,
      tipo: tipo ?? this.tipo,
    );
  }
}

class ListaCompras{
  int? id;
  String nome;
  String? observacao;
  int createdAt;

  ListaCompras({this.id, required this.nome, this.observacao, int? createdAt})
        : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'observacao': observacao,
    'createdAt': createdAt,
  };

  factory ListaCompras.fromMap(Map<String, dynamic> m) => ListaCompras(
    id: m['id'],
    nome: m['nome'],
    observacao: m['observacao'],
    createdAt: m['createdAt'],
  );
}
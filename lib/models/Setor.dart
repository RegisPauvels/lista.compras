class Setor{
  int? id;
  String nome;
  int createdAt;

  Setor({this.id, required this.nome, int? createdAt})
      : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'createdAt': createdAt,
  };

  factory Setor.fromMap(Map<String, dynamic> m) => Setor(
    id: m['id'],
    nome: m['nome'],
    createdAt: m['createdAt'],
  );
}
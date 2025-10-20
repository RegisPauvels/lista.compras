class ItemCompras{
  int? id;
  int listaId;
  int? setorId;
  String nome;
  int quantidade;
  bool comprado;
  int? compradoAt;
  int createdAt;

  ItemCompras({
    this.id,
    required this.listaId,
    required this.setorId,
    required this.nome,
    this.quantidade = 1,
    this.comprado = false,
    this.compradoAt,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() => {
    'id': id,
    'listaId': listaId,
    'setorId': setorId,
    'nome': nome,
    'quantidade': quantidade,
    'comprado': comprado ? 1 : 0,
    'compradoAt': compradoAt,
    'createdAt': createdAt,
  };

  factory ItemCompras.fromMap(Map<String, dynamic> m) => ItemCompras(
    id: m['id'],
    listaId: m['listaId'],
    setorId: m['setorId'],
    nome: m['nome'],
    quantidade: m['quantidade'],
    comprado: (m['comprado'] ?? 0) == 1,
    compradoAt: m['compradoAt'],
    createdAt: m['createdAt'],
  );
}
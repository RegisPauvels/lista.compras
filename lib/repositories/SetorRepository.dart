import 'package:lista_compras/models/Setor.dart';
import 'package:lista_compras/services/BancoDadosService.dart';

class SetorRepository{
  final _bdService = BancoDadosService();

  Future<List<Setor>> getAllSetores() async {
    final data = await _bdService.queryAll('setores');
    return data.map((e) => Setor.fromMap(e)).toList();
  }

  Future<void> insertSetor(Setor setor) async {
    await _bdService.insert('setores', setor.toMap());
  }

  Future<int> updateSetor(Setor setor) async {
    return await _bdService.update('setores', setor.toMap(), setor.id!);
  }

  Future<void> deleteSetor(int id) async {
    await _bdService.delete('setores', id);
  }

  Future<Setor?> getSetorById(int id) async {
    final data = await _bdService.queryWhere(
      'setores',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (data.isNotEmpty) {
      return Setor.fromMap(data.first);
    } else {
      return null;
    }
  }
}
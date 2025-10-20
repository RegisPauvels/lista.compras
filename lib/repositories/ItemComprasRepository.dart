import 'package:lista_compras/models/ItemCompras.dart';
import 'package:lista_compras/services/BancoDadosService.dart';
import 'package:sqflite/sqflite.dart';

class ItemComprasRepository{
  final _bdService = BancoDadosService();

  Future<List<ItemCompras>> getItemsByList(int listId) async {
    final data = await _bdService.queryWhere(
      'item_compras',
      where: 'listaId = ?',
      whereArgs: [listId],
    );
    return data.map((e) => ItemCompras.fromMap(e)).toList();
  }

  Future<void> insertItem(ItemCompras item) async {
    await _bdService.insert('item_compras', item.toMap());
  }

  Future<void> updateItem(ItemCompras item) async {
    await _bdService.update('item_compras', item.toMap(), item.id!);
  }

  Future<void> deleteItem(int id) async {
    await _bdService.delete('item_compras', id);
  }

  Future<void> marcarItemComprado(int id, bool comprado) async {
    final now = comprado ? DateTime.now().millisecondsSinceEpoch : null;
    await _bdService.update('item_compras', {'comprado': comprado ? 1 : 0, 'compradoAt': now}, id);
  }

  Future<int> countItensRestantes(int listId) async {
    final db = await _bdService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM item_compras WHERE listaId = ? AND comprado = 0',
      [listId],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countItensComprados(int listId) async {
    final db = await _bdService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM item_compras WHERE listaId = ? AND comprado = 1',
      [listId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countAll(int listId) async {
    final result = await _bdService.database.then(
          (db) => db.rawQuery(
        'SELECT COUNT(*) as total FROM item_compras WHERE listaId = ?',
        [listId],
      ),
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<ItemCompras>> getAllItens() async {
    final data = await _bdService.queryAll('item_compras');
    return data.map((e) => ItemCompras.fromMap(e)).toList();
  }

}
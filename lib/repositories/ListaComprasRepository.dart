import 'package:lista_compras/models/ListaCompras.dart';
import 'package:lista_compras/services/BancoDadosService.dart';

class ListaComprasRepository{
  final _bdService = BancoDadosService();

  Future<List<ListaCompras>> getAllListas() async {
    final data = await _bdService.queryAll('lista_compras');
    return data.map((e) => ListaCompras.fromMap(e)).toList();
  }

  Future<void> insertLista(ListaCompras lista) async {
    await _bdService.insert('lista_compras', lista.toMap());
  }

  Future<void> updateLista(ListaCompras lista) async {
    await _bdService.update('lista_compras', lista.toMap(), lista.id!);
  }

  Future<void> deleteLista(int id) async {
    await _bdService.delete('lista_compras', id);
  }
}
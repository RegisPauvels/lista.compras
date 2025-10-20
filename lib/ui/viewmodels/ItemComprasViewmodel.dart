import 'package:flutter/material.dart';
import 'package:lista_compras/models/ItemCompras.dart';
import 'package:lista_compras/repositories/ItemComprasRepository.dart';

class ItemComprasViewmodel extends ChangeNotifier {
  final _repository = ItemComprasRepository();

  List<ItemCompras> itens = [];
  bool carregando = false;
  int setorSelecionadoId = -1; // -1 => todos


  Future<void> loadItems(int listId) async {
    carregando = true;
    notifyListeners();

    if (setorSelecionadoId == -1) {
      itens = await _repository.getItemsByList(listId);
    } else {
      itens = (await _repository.getItemsByList(listId))
          .where((i) => i.setorId == setorSelecionadoId)
          .toList();
    }

    carregando = false;
    notifyListeners();
  }

  void setSetor(int setorId) {
    setorSelecionadoId = setorId;
    notifyListeners();
  }

  Future<void> addItem(ItemCompras i, int listId) async {
    await _repository.insertItem(i);
    await loadItems(listId);
  }

  Future<void> updateItem(ItemCompras i, int listId) async {
    await _repository.updateItem(i);
    await loadItems(listId);
  }

  Future<void> deleteItem(int id, int listId) async {
    await _repository.deleteItem(id);
    await loadItems(listId);
  }

  Future<void> alterarComprado(ItemCompras item, int listId) async {
    await _repository.marcarItemComprado(item.id!, !item.comprado);
    await loadItems(listId);
  }

  Future<int> countRestantes(int listId) async {
    return await _repository.countItensRestantes(listId);
  }

  Future<int> countAll(int listId) async {
    return await _repository.countAll(listId);
  }

  Future<int> countComprados(int listId) async {
    return await _repository.countItensComprados(listId);
  }

  Future<List<ItemCompras>> getItensFaltantes() async {
    final all = await _repository.getAllItens();
    return all.where((i) => !i.comprado).toList();
  }

  Future<List<ItemCompras>> getItensFaltantesPorSetor(int setorId) async {
    final all = await _repository.getAllItens();
    return all.where((i) => !i.comprado && i.setorId == setorId).toList();
  }

  Future<List<ItemCompras>> getAllItens() async {
    return await _repository.getAllItens();
  }


}

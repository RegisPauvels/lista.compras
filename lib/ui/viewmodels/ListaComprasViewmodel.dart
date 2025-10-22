import 'package:flutter/foundation.dart';
import 'package:lista_compras/models/ListaCompras.dart';
import 'package:lista_compras/repositories/ListaComprasRepository.dart';

class ListaComprasViewmodel extends ChangeNotifier{
  final _repository = ListaComprasRepository();
  List<ListaCompras> lists = [];

  Future<void> loadListas() async {
    lists = await _repository.getAllListas();
    notifyListeners();
  }

  Future<void> insertLista(String nome) async {
    await _repository.insertLista(ListaCompras(nome: nome));
    await loadListas();
  }

  Future<void> updateLista(ListaCompras lista) async {
    await _repository.updateLista(lista);
    await loadListas();
  }

  Future<void> deleteLista(int id) async {
    await _repository.deleteLista(id);
    await loadListas();
  }
}
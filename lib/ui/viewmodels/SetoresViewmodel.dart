import 'package:flutter/material.dart';
import 'package:lista_compras/models/Setor.dart';
import 'package:lista_compras/repositories/SetorRepository.dart';

class SetoresViewmodel extends ChangeNotifier {
  final _repository = SetorRepository();
  List<Setor> setores = [];

  Future<void> loadSetores() async {
    setores = await _repository.getAllSetores();
    notifyListeners();
  }

  Future<void> addSetor(String nome) async {
    await _repository.insertSetor(Setor(nome: nome));
    await loadSetores();
  }

  Future<void> updateSetor(Setor s) async {
    await _repository.updateSetor(s);
    await loadSetores();
  }

  Future<void> deleteSetor(int id) async {
    await _repository.deleteSetor(id);
    await loadSetores();
  }

  Future<Setor?> getById(int id) async {
    return await _repository.getSetorById(id);
  }
}

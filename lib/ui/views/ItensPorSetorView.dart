import 'package:flutter/material.dart';
import 'package:lista_compras/ui/viewmodels/ItemComprasViewmodel.dart';
import 'package:lista_compras/ui/viewmodels/SetoresViewmodel.dart';

import '../../models/ItemCompras.dart';
import '../../models/Setor.dart';

class ItensPorSetorView extends StatefulWidget {
  const ItensPorSetorView({super.key});

  @override
  State<ItensPorSetorView> createState() => _ItensPorSetorViewState();
}

class _ItensPorSetorViewState extends State<ItensPorSetorView> {
  final _setorVM = SetoresViewmodel();
  final _itemVM = ItemComprasViewmodel();
  List<Setor> _setores = [];
  Map<int, List<ItemCompras>> _itensPorSetor = {};

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    await _setorVM.loadSetores();
    final setores = _setorVM.setores;
    final mapa = <int, List<ItemCompras>>{};
    for (var s in setores) {
      mapa[s.id!] = await _itemVM.getItensFaltantesPorSetor(s.id!);
    }

    setState(() {
      _setores = setores;
      _itensPorSetor = mapa;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Itens por Setor")),
      body: _setores.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _setores.length,
        itemBuilder: (context, i) {
          final setor = _setores[i];
          final itens = _itensPorSetor[setor.id] ?? [];

          return ExpansionTile(
            title: Text(setor.nome),
            subtitle: Text("${itens.length} itens faltantes"),
            children: itens.isEmpty
                ? [const ListTile(title: Text("Nenhum item pendente"))]
                : itens.map((item) {
              return ListTile(
                title: Text(item.nome),
                subtitle: Text("Qtd: ${item.quantidade ?? 1}"),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
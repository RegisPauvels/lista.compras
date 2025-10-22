import 'package:flutter/material.dart';
import 'package:lista_compras/models/ItemCompras.dart';
import 'package:lista_compras/models/Setor.dart';
import 'package:lista_compras/ui/viewmodels/ItemComprasViewmodel.dart';
import '../viewmodels/SetoresViewmodel.dart';

class ItensCompraView extends StatefulWidget {
  final int listaId;
  final String nomeLista;

  const ItensCompraView({super.key, required this.listaId, required this.nomeLista});

  @override
  State<ItensCompraView> createState() => _ItensCompraViewState();
}

class _ItensCompraViewState extends State<ItensCompraView> {
  final _itensVM = ItemComprasViewmodel();
  final _setoresVM = SetoresViewmodel();
  List<ItemCompras> _itens = [];
  String? _setorSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarItens();
    _loadSetores();
  }

  Future<void> _loadSetores() async {
    await _setoresVM.loadSetores();
    setState(() {});
  }

  Future<void> _carregarItens() async {
    if (_setorSelecionado == null) {
      _itensVM.setSetor(-1);
    } else {
      final setor = _setoresVM.setores.firstWhere((s) => s.nome == _setorSelecionado);
      _itensVM.setSetor(setor.id!);
    }

    await _itensVM.loadItems(widget.listaId);
    setState(() => _itens = _itensVM.itens);
  }

  Future<void> _toggleComprado(ItemCompras item) async {
    await _itensVM.alterarComprado(item, widget.listaId);
    _carregarItens();
  }

  Future<void> _removerItem(ItemCompras item) async {
    await _itensVM.deleteItem(item.id!, item.listaId);
    _carregarItens();
  }

  Future<void> _adicionarItem() async {
    final nomeController = TextEditingController();
    final quantidadeController = TextEditingController();

    Setor? setorSelecionado;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Adicionar Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome do item'),
            ),
            TextField(
              controller: quantidadeController,
              decoration: const InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<Setor>(
              isExpanded: true,
              hint: const Text("Escolher setor"),
              value: setorSelecionado,
              items: _setoresVM.setores
                  .map((s) => DropdownMenuItem(
                value: s,
                child: Text(s.nome),
              ))
                  .toList(),
              onChanged: (v) => setState(() => setorSelecionado = v),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              if (nomeController.text.isNotEmpty && setorSelecionado != null) {
                final item = ItemCompras(
                  nome: nomeController.text,
                  quantidade: int.tryParse(quantidadeController.text) ?? 1,
                  setorId: setorSelecionado!.id,
                  listaId: widget.listaId,
                  comprado: false,
                );
                _itensVM.addItem(item, widget.listaId);
                Navigator.pop(context);
                _carregarItens();
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista: ${widget.nomeLista}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarItens,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Filtrar por setor"),
              value: _setorSelecionado,
              items: _setoresVM.setores
                  .map((s) => DropdownMenuItem(
                value: s.nome,
                child: Text(s.nome),
              ))
                  .toList(),
              onChanged: (v) {
                setState(() => _setorSelecionado = v);
                _carregarItens();
              },
            ),
          ),
          Expanded(
            child: _itens.isEmpty
                ? const Center(child: Text("Nenhum item encontrado"))
                : ListView.builder(
              itemCount: _itens.length,
              itemBuilder: (context, i) {
                final item = _itens[i];
                return ListTile(
                  title: Text(
                    item.nome,
                    style: TextStyle(
                      decoration:
                      item.comprado ? TextDecoration.lineThrough : TextDecoration.none,
                      color: item.comprado ? Colors.grey : Colors.white,
                    ),
                  ),
                  subtitle: Text('Qtd: ${item.quantidade ?? 1}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: item.comprado,
                        onChanged: (_) => _toggleComprado(item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removerItem(item),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lista_compras/ui/viewmodels/ItemComprasViewmodel.dart';
import '../../models/ItemCompras.dart';

class TodosItensView extends StatefulWidget {
  const TodosItensView({super.key});

  @override
  State<TodosItensView> createState() => _TodosItensViewState();
}

class _TodosItensViewState extends State<TodosItensView> {
  final _viewModel = ItemComprasViewmodel();
  List<ItemCompras> _itensFaltantes = [];
  List<ItemCompras> _itensComprados = [];

  @override
  void initState() {
    super.initState();
    _carregarItens();
  }

  Future<void> _carregarItens() async {
    final todos = await _viewModel.getAllItens();
    setState(() {
      _itensFaltantes = todos.where((i) => !i.comprado).toList();
      _itensComprados = todos.where((i) => i.comprado).toList();
    });
  }

  Future<void> _toggleComprado(ItemCompras item) async {
    await _viewModel.alterarComprado(item, item.listaId);
    _carregarItens();
  }

  Future<void> _removerItem(ItemCompras item) async {
    await _viewModel.deleteItem(item.id!, item.listaId);
    _carregarItens();
  }

  Widget _buildItemTile(ItemCompras item) {
    return ListTile(
      title: Text(
        item.nome,
        style: TextStyle(
          decoration: item.comprado ? TextDecoration.lineThrough : null,
          color: item.comprado ? Colors.grey : Colors.black,
        ),
      ),
      subtitle: Text('Lista: ${item.listaId} - Qtd: ${item.quantidade ?? 1}'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos os Itens"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarItens,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            if (_itensFaltantes.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Itens Faltantes",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ..._itensFaltantes.map(_buildItemTile),
            ] else
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Nenhum item faltante"),
              ),

            const Divider(),


            if (_itensComprados.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Itens Comprados",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ..._itensComprados.map(_buildItemTile),
            ] else
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Nenhum item comprado"),
              ),
          ],
        ),
      ),
    );
  }
}

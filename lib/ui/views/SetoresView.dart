import 'package:flutter/material.dart';
import 'package:lista_compras/ui/viewmodels/SetoresViewmodel.dart';

class SetoresView extends StatefulWidget {
  const SetoresView({super.key});

  @override
  State<SetoresView> createState() => _SetoresViewState();
}

class _SetoresViewState extends State<SetoresView> {
  final _viewModel = SetoresViewmodel();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarSetores();
  }

  Future<void> _carregarSetores() async {
    await _viewModel.loadSetores();
    setState(() {});
  }

  Future<void> _adicionarSetor() async {
    if (_controller.text.isEmpty) return;
    await _viewModel.addSetor(_controller.text);
    _controller.clear();
    _carregarSetores();
  }

  Future<void> _excluirSetor(int id) async {
    await _viewModel.deleteSetor(id);
    _carregarSetores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gerenciar Setores")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Novo Setor",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _adicionarSetor,
                  child: const Text("Adicionar"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _viewModel.setores.length,
              itemBuilder: (context, i) {
                final s = _viewModel.setores[i];
                return ListTile(
                  title: Text(s.nome),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _excluirSetor(s.id!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


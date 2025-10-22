import 'package:flutter/material.dart';
import 'package:lista_compras/ui/viewmodels/ListaComprasViewmodel.dart';
import 'package:lista_compras/ui/viewmodels/ItemComprasViewmodel.dart';
import 'package:lista_compras/ui/views/ItensCompraView.dart';
import 'package:lista_compras/ui/views/ItensPorSetorView.dart';
import 'package:lista_compras/ui/views/SetoresView.dart';
import 'package:lista_compras/ui/views/TodosItensView.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ListaComprasViewmodel>();
    final itemVM = ItemComprasViewmodel();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Listas de Compras'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Itens por setores',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ItensPorSetorView()),
              );
              await vm.loadListas();
            },
          ),
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'Gerenciar Setores',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SetoresView()),
              );
              await vm.loadListas();
            },
          ),
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Ver todos os itens faltantes',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TodosItensView()),
              );
              await vm.loadListas();
            },
          ),
        ],
      ),
      body: vm.lists.isEmpty
          ? const Center(child: Text("Nenhuma lista cadastrada"))
          : ListView.builder(
        itemCount: vm.lists.length,
        itemBuilder: (_, i) {
          final list = vm.lists[i];

          return FutureBuilder(
            future: Future.wait([
              itemVM.countAll(list.id!),
              itemVM.countComprados(list.id!),
              itemVM.countRestantes(list.id!),
            ]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const ListTile(
                  title: Text("Carregando..."),
                );
              }

              final counts = snapshot.data!;
              final total = counts[0] as int;
              final comprados = counts[1] as int;
              final restantes = counts[2] as int;

              return ListTile(
                title: Text(
                  '${list.id} - ${list.nome}',
                  style: TextStyle(
                    decoration: restantes == 0
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Text(
                  "Total: $total | Comprados: $comprados | Restantes: $restantes",
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Editar lista',
                      onPressed: () async {
                        final novoNome = await _dialogEditarLista(
                            context, list.nome);
                        if (novoNome != null && novoNome.isNotEmpty) {
                          list.nome = novoNome;
                          await vm.updateLista(list);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Excluir lista',
                      onPressed: () async {
                        await vm.deleteLista(list.id!);
                      },
                    ),
                  ],
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ItensCompraView(
                        listaId: list.id!,
                        nomeLista: list.nome,
                      ),
                    ),
                  );
                  await vm.loadListas();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nome = await _dialogNovaLista(context);
          if (nome != null && nome.isNotEmpty) {
            await vm.insertLista(nome);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String?> _dialogNovaLista(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nova lista'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nome da lista'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<String?> _dialogEditarLista(
      BuildContext context, String nomeAtual) async {
    final controller = TextEditingController(text: nomeAtual);
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar lista'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Novo nome da lista'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}

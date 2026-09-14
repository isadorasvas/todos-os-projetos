import 'package:flutter/material.dart';

import 'database/database_helper.dart';
import 'models/tarefa.dart';

void main() {
  runApp(const TarefasDbApp());
}

class TarefasDbApp extends StatelessWidget {
  const TarefasDbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas SQLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const TarefasScreen(),
    );
  }
}

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  List<Tarefa> _tarefas = [];

  bool _carregando = true;

  int _totalTarefas = 0;

  final TextEditingController _buscaController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _atualizarLista();
  }

  @override
  void dispose() {
    _buscaController.dispose();

    super.dispose();
  }

  // Carregar tarefas e atualizar contador
  Future<void> _atualizarLista() async {
    setState(() {
      _carregando = true;
    });

    final dados =
        await DatabaseHelper.instance.queryAll();

    final total =
        await DatabaseHelper.instance.count();

    setState(() {
      _tarefas = dados;
      _totalTarefas = total;
      _carregando = false;
    });
  }

  // Adicionar tarefa
  Future<void> _adicionarTarefa(String titulo) async {
    if (titulo.trim().isEmpty) {
      return;
    }

    await DatabaseHelper.instance.insert(
      Tarefa(
        titulo: titulo.trim(),
      ),
    );

    await _atualizarLista();
  }

  // Alterar status da tarefa
  Future<void> _alternarStatus(Tarefa tarefa) async {
    final atualizada = tarefa.copyWith(
      concluida: !tarefa.concluida,
    );

    await DatabaseHelper.instance.update(atualizada);

    await _atualizarLista();
  }

  // Excluir uma tarefa
  Future<void> _removerTarefa(int id) async {
    await DatabaseHelper.instance.delete(id);

    await _atualizarLista();
  }

  // EXERCÍCIO 02
  // Excluir todas as tarefas
  Future<void> _removerTodasTarefas() async {
    await DatabaseHelper.instance.deleteAll();

    await _atualizarLista();
  }

  // Confirmar exclusão de todas as tarefas
  void _confirmarExclusaoTodas() {
    if (_totalTarefas == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não existem tarefas para excluir.'),
        ),
      );

      return;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text(
            'Limpar todas as tarefas',
          ),
          content: const Text(
            'Tem certeza que deseja excluir todas as tarefas?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(ctx);

                await _removerTodasTarefas();

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Todas as tarefas foram excluídas.',
                    ),
                  ),
                );
              },
              child: const Text('Excluir todas'),
            ),
          ],
        );
      },
    );
  }

  // EXERCÍCIO 03
  // Buscar tarefas pelo título
  Future<void> _buscarTarefas(String texto) async {
    if (texto.trim().isEmpty) {
      await _atualizarLista();

      return;
    }

    setState(() {
      _carregando = true;
    });

    final dados =
        await DatabaseHelper.instance.search(texto);

    setState(() {
      _tarefas = dados;
      _carregando = false;
    });
  }

  // Limpar busca
  Future<void> _limparBusca() async {
    _buscaController.clear();

    await _atualizarLista();
  }

  // Dialog para cadastrar tarefa
  void _exibirDialogCadastro() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text(
            'Nova Tarefa (SQLite)',
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Descrição da tarefa',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _adicionarTarefa(
                  controller.text,
                );

                if (ctx.mounted) {
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Persistência Relacional (SQLite)',
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,

        // EXERCÍCIO 02
        // Botão para excluir todas
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_sweep,
            ),
            tooltip: 'Excluir todas',
            onPressed: _confirmarExclusaoTodas,
          ),
        ],
      ),

      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [

                // EXERCÍCIO 03
                // Campo de busca
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _buscaController,
                    onChanged: _buscarTarefas,
                    decoration: InputDecoration(
                      labelText: 'Buscar tarefa',
                      hintText:
                          'Digite o título da tarefa',
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.clear,
                        ),
                        onPressed: _limparBusca,
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),

                // Lista de tarefas
                Expanded(
                  child: _tarefas.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhuma tarefa encontrada.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _tarefas.length,
                          itemBuilder: (ctx, i) {
                            final t = _tarefas[i];

                            return Card(
                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: ListTile(
                                leading: Checkbox(
                                  value: t.concluida,
                                  onChanged: (_) {
                                    _alternarStatus(t);
                                  },
                                ),

                                title: Text(
                                  t.titulo,
                                  style: TextStyle(
                                    decoration: t.concluida
                                        ? TextDecoration
                                            .lineThrough
                                        : TextDecoration.none,
                                    color: t.concluida
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),

                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _removerTarefa(
                                      t.id!,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // EXERCÍCIO 01
                // Contador no rodapé
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.teal,
                  child: Text(
                    'Total de tarefas: $_totalTarefas',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

      // Botão para adicionar tarefa
      floatingActionButton: FloatingActionButton(
        onPressed: _exibirDialogCadastro,
        backgroundColor: Colors.teal,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tarefa_provider.dart';
import '../models/tarefa.dart';
import '../widgets/tarefa_card.dart';

const _tipos = ['pessoal', 'trabalho', 'estudo', 'outro'];

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  String? _filtroTipo;

  List<Tarefa> _filtrar(List<Tarefa> tarefas) {
    if (_filtroTipo == null) return tarefas;
    return tarefas.where((t) => t.tipo == _filtroTipo).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tarefas'),
          actions: [
            PopupMenuButton<String?>(
              icon: Icon(
                Icons.filter_list,
                color: _filtroTipo != null ? Colors.black : const Color(0xFF757575),
              ),
              tooltip: 'Filtrar por tipo',
              onSelected: (tipo) => setState(() => _filtroTipo = tipo),
              itemBuilder: (_) => [
                PopupMenuItem<String?>(
                  value: null,
                  child: Row(
                    children: [
                      Icon(
                        _filtroTipo == null ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        size: 18,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      const Text('Todos os tipos'),
                    ],
                  ),
                ),
                ..._tipos.map(
                  (tipo) => PopupMenuItem<String?>(
                    value: tipo,
                    child: Row(
                      children: [
                        Icon(
                          _filtroTipo == tipo ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          size: 18,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8),
                        Text(tipo[0].toUpperCase() + tipo.substring(1)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Color(0xFF757575),
            indicatorColor: Colors.black,
            indicatorWeight: 2,
            tabs: [
              Tab(text: 'Todas'),
              Tab(text: 'Importantes'),
              Tab(text: 'Realizadas'),
              Tab(text: 'Pendentes'),
              Tab(text: 'Atrasadas'),
            ],
          ),
        ),
        body: Consumer<TarefaProvider>(
          builder: (context, provider, _) {
            return TabBarView(
              children: [
                _Lista(tarefas: _filtrar(provider.tarefas)),
                _Lista(tarefas: _filtrar(provider.importantes)),
                _Lista(tarefas: _filtrar(provider.realizadas)),
                _Lista(tarefas: _filtrar(provider.naoRealizadas)),
                _Lista(tarefas: _filtrar(provider.atrasadas)),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(),
          onPressed: () => Navigator.pushNamed(context, '/inserir'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _Lista extends StatelessWidget {
  final List<Tarefa> tarefas;

  const _Lista({required this.tarefas});

  @override
  Widget build(BuildContext context) {
    if (tarefas.isEmpty) {
      return const Center(
        child: Text('Nenhuma tarefa.', style: TextStyle(color: Color(0xFF757575))),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: tarefas.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => TarefaCard(tarefa: tarefas[index]),
    );
  }
}

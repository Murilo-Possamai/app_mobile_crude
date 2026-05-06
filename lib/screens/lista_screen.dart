import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tarefa_provider.dart';
import '../models/tarefa.dart';
import '../widgets/tarefa_card.dart';

class ListaScreen extends StatelessWidget {
  const ListaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tarefas'),
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
                _Lista(tarefas: provider.tarefas),
                _Lista(tarefas: provider.importantes),
                _Lista(tarefas: provider.realizadas),
                _Lista(tarefas: provider.naoRealizadas),
                _Lista(tarefas: provider.atrasadas),
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

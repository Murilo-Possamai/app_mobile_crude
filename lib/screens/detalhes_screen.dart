import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tarefa.dart';
import '../providers/tarefa_provider.dart';

class DetalhesScreen extends StatelessWidget {
  final Tarefa tarefa;

  const DetalhesScreen({super.key, required this.tarefa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mode_edit_outline),
            onPressed: () => Navigator.pushNamed(context, '/editar', arguments: tarefa),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => _confirmarExclusao(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Rotulo('Título'),
            _Dado(tarefa.titulo),
            const SizedBox(height: 20),
            _Rotulo('Descrição'),
            _Dado(tarefa.descricao),
            const SizedBox(height: 20),
            _Rotulo('Data prevista'),
            _Dado(tarefa.dataPrevista),
            const SizedBox(height: 20),
            _Rotulo('Tipo'),
            _Dado(tarefa.tipo),
            const SizedBox(height: 20),
            Row(
              children: [
                _Tag(
                  label: tarefa.importante ? 'Importante' : 'Normal',
                  color: tarefa.importante ? const Color(0xFFFF3B30) : const Color(0xFF757575),
                ),
                const SizedBox(width: 8),
                _Tag(
                  label: tarefa.realizada ? 'Realizada' : 'Pendente',
                  color: tarefa.realizada ? Colors.black : const Color(0xFF757575),
                ),
              ],
            ),
            const Spacer(),
            if (!tarefa.realizada)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: () => _concluir(context),
                  child: const Text('Marcar como realizada'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _concluir(BuildContext context) async {
    await context.read<TarefaProvider>().concluir(tarefa);
    if (context.mounted) Navigator.pop(context);
  }

  void _confirmarExclusao(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir tarefa'),
        content: const Text('Tem certeza que deseja excluir esta tarefa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<TarefaProvider>().deletar(tarefa.id!);
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Color(0xFFFF3B30))),
          ),
        ],
      ),
    );
  }
}

class _Rotulo extends StatelessWidget {
  final String text;
  const _Rotulo(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 11, color: Color(0xFF757575), letterSpacing: 1.2),
    );
  }
}

class _Dado extends StatelessWidget {
  final String text;
  const _Dado(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: color)),
      child: Text(label, style: TextStyle(fontSize: 12, color: color)),
    );
  }
}

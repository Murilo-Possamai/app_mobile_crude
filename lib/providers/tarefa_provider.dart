import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../models/tarefa.dart';

class TarefaProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Tarefa> _tarefas = [];

  List<Tarefa> get tarefas => _tarefas;

  List<Tarefa> get importantes => _tarefas.where((t) => t.importante).toList();

  List<Tarefa> get realizadas => _tarefas.where((t) => t.realizada).toList();

  List<Tarefa> get naoRealizadas => _tarefas.where((t) => !t.realizada).toList();

  List<Tarefa> get atrasadas => _tarefas.where((t) {
        if (t.realizada) return false;
        final data = DateTime.tryParse(t.dataPrevista);
        return data != null && data.isBefore(DateTime.now());
      }).toList();

  Tarefa? get proximaTarefa {
    final pendentes = naoRealizadas;
    if (pendentes.isEmpty) return null;
    pendentes.sort((a, b) => a.dataPrevista.compareTo(b.dataPrevista));
    return pendentes.first;
  }

  Future<void> buscar() async {
    _tarefas = await _db.buscarTodas();
    notifyListeners();
  }

  Future<void> inserir(Tarefa tarefa) async {
    await _db.inserir(tarefa);
    await buscar();
  }

  Future<void> atualizar(Tarefa tarefa) async {
    await _db.atualizar(tarefa);
    await buscar();
  }

  Future<void> deletar(int id) async {
    await _db.deletar(id);
    await buscar();
  }

  Future<void> concluir(Tarefa tarefa) async {
    await atualizar(tarefa.copyWith(realizada: true));
  }
}

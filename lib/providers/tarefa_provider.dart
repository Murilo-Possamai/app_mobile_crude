import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../models/tarefa.dart';

class TarefaProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Tarefa> _tarefas = [];

  List<Tarefa> get tarefas => _tarefas;

  List<Tarefa> get importantes => _tarefas.where((t) => t.importante).toList();

  List<Tarefa> get naoImportantes => _tarefas.where((t) => !t.importante).toList();

  List<Tarefa> get realizadas => _tarefas.where((t) => t.realizada).toList();

  List<Tarefa> get naoRealizadas => _tarefas.where((t) => !t.realizada).toList();

  List<Tarefa> get atrasadas {
    final hoje = DateTime.now();
    return _tarefas.where((t) {
      final data = DateTime.tryParse(t.dataPrevista);
      return data != null && data.isBefore(hoje) && !t.realizada;
    }).toList();
  }

  List<Tarefa> get naoAtrasadas {
    final hoje = DateTime.now();
    return _tarefas.where((t) {
      final data = DateTime.tryParse(t.dataPrevista);
      return data == null || !data.isBefore(hoje) || t.realizada;
    }).toList();
  }

  Tarefa? get tarefaMaisProxima {
    final pendentes = _tarefas.where((t) => !t.realizada).toList();
    if (pendentes.isEmpty) return null;
    pendentes.sort((a, b) => a.dataPrevista.compareTo(b.dataPrevista));
    return pendentes.first;
  }

  Future<void> carregar() async {
    _tarefas = await _db.listarTodas();
    notifyListeners();
  }

  Future<void> inserir(Tarefa tarefa) async {
    await _db.inserir(tarefa);
    await carregar();
  }

  Future<void> atualizar(Tarefa tarefa) async {
    await _db.atualizar(tarefa);
    await carregar();
  }

  Future<void> deletar(int id) async {
    await _db.deletar(id);
    await carregar();
  }

  Future<void> marcarRealizada(Tarefa tarefa) async {
    await atualizar(tarefa.copyWith(realizada: true));
  }
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tarefa.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;

  DatabaseHelper._();

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'tarefas.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tarefas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        data_prevista TEXT NOT NULL,
        importante INTEGER NOT NULL DEFAULT 0,
        realizada INTEGER NOT NULL DEFAULT 0,
        tipo TEXT NOT NULL
      )
    ''');
  }

  Future<int> inserir(Tarefa tarefa) async {
    final database = await db;
    return database.insert('tarefas', tarefa.toMap());
  }

  Future<List<Tarefa>> buscarTodas() async {
    final database = await db;
    final maps = await database.query('tarefas', orderBy: 'data_prevista ASC');
    return maps.map(Tarefa.fromMap).toList();
  }

  Future<int> atualizar(Tarefa tarefa) async {
    final database = await db;
    return database.update(
      'tarefas',
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  Future<int> deletar(int id) async {
    final database = await db;
    return database.delete('tarefas', where: 'id = ?', whereArgs: [id]);
  }
}

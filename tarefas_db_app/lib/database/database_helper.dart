import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/tarefa.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB();

    return _database!;
  }

  Future<Database> _initDB() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;

      return await databaseFactory.openDatabase(
        'tarefas_local.db',
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _createDB,
        ),
      );
    }

    final databasesPath = await getDatabasesPath();

    final path = '$databasesPath/tarefas_local.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE tarefas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        concluida INTEGER NOT NULL
      )
    ''');
  }

  // Inserir tarefa
  Future<int> insert(Tarefa tarefa) async {
    final db = await database;

    return await db.insert(
      'tarefas',
      tarefa.toMap(),
    );
  }

  // Buscar todas as tarefas
  Future<List<Tarefa>> queryAll() async {
    final db = await database;

    final result = await db.query(
      'tarefas',
      orderBy: 'id DESC',
    );

    return result
        .map((json) => Tarefa.fromMap(json))
        .toList();
  }

  // Atualizar tarefa
  Future<int> update(Tarefa tarefa) async {
    final db = await database;

    return await db.update(
      'tarefas',
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  // Excluir uma tarefa
  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      'tarefas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // EXERCÍCIO 01
  // Contar a quantidade total de tarefas
  Future<int> count() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM tarefas',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // EXERCÍCIO 02
  // Excluir todas as tarefas
  Future<int> deleteAll() async {
    final db = await database;

    return await db.delete('tarefas');
  }

  // EXERCÍCIO 03
  // Buscar tarefas pelo título usando LIKE
  Future<List<Tarefa>> search(String texto) async {
    final db = await database;

    final result = await db.query(
      'tarefas',
      where: 'titulo LIKE ?',
      whereArgs: ['%$texto%'],
      orderBy: 'id DESC',
    );

    return result
        .map((json) => Tarefa.fromMap(json))
        .toList();
  }
}
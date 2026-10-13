import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import '../../models/unfinished_recipe_model.dart';

class LocalSqlDatabaseService {
  LocalSqlDatabaseService._();
  static final LocalSqlDatabaseService instance = LocalSqlDatabaseService._();

  Database? _database;
  // In-memory fallback for web environment where sqflite native driver is unavailable
  final Map<String, UnfinishedRecipeModel> _webMemoryStore = {};
  final StreamController<void> _changeController = StreamController<void>.broadcast();

  Stream<void> get onDatabaseChanged => _changeController.stream;

  Future<void> init() async {
    if (kIsWeb) return;

    try {
      final dbPath = await getDatabasesPath();
      final path = p.join(dbPath, 'cukkie_local.db');

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS unfinished_recipes (
              dish_id TEXT PRIMARY KEY,
              dish_name TEXT NOT NULL,
              dish_image TEXT,
              step_index INTEGER NOT NULL,
              step_heading TEXT NOT NULL,
              portion_amount REAL NOT NULL,
              completed_todos_json TEXT,
              last_interacted_at INTEGER NOT NULL
            )
          ''');
        },
      );
    } catch (e) {
      debugPrint('LocalSqlDatabaseService init error: $e');
    }
  }

  Future<void> saveProgress(UnfinishedRecipeModel entry) async {
    if (kIsWeb || _database == null) {
      _webMemoryStore[entry.dishId] = entry;
      _changeController.add(null);
      return;
    }

    try {
      await _database!.insert(
        'unfinished_recipes',
        entry.toSqlMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      _changeController.add(null);
    } catch (e) {
      debugPrint('Error saving unfinished recipe progress: $e');
    }
  }

  Future<List<UnfinishedRecipeModel>> getUnfinishedRecipes() async {
    if (kIsWeb || _database == null) {
      final list = _webMemoryStore.values.toList();
      list.sort((a, b) => b.lastInteractedAt.compareTo(a.lastInteractedAt));
      return list;
    }

    try {
      final maps = await _database!.query(
        'unfinished_recipes',
        orderBy: 'last_interacted_at DESC',
      );
      return maps.map((m) => UnfinishedRecipeModel.fromSqlMap(m)).toList();
    } catch (e) {
      debugPrint('Error getting unfinished recipes: $e');
      return [];
    }
  }

  Future<UnfinishedRecipeModel?> getRecipeProgress(String dishId) async {
    if (kIsWeb || _database == null) {
      return _webMemoryStore[dishId];
    }

    try {
      final maps = await _database!.query(
        'unfinished_recipes',
        where: 'dish_id = ?',
        whereArgs: [dishId],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return UnfinishedRecipeModel.fromSqlMap(maps.first);
      }
    } catch (e) {
      debugPrint('Error getting recipe progress: $e');
    }
    return null;
  }

  Future<void> removeRecipe(String dishId) async {
    if (kIsWeb || _database == null) {
      _webMemoryStore.remove(dishId);
      _changeController.add(null);
      return;
    }

    try {
      await _database!.delete(
        'unfinished_recipes',
        where: 'dish_id = ?',
        whereArgs: [dishId],
      );
      _changeController.add(null);
    } catch (e) {
      debugPrint('Error removing unfinished recipe: $e');
    }
  }
}
